-- cmd+space: small centered, searchable app launcher (Spotlight-style)
local menuPosition = require("menu_position")

local home = os.getenv("HOME")

local appDirs = {
	"/Applications",
	"/System/Applications",
	home .. "/Applications",
	-- Games and other apps that live in their own folders
	home .. "/Library/Application Support/Steam/steamapps/common",
	home .. "/Games",
	"/Users/Shared",
}

-- Apps on external drives (/Volumes/<drive>/Applications, /Volumes/<drive>/Games)
local function volumeDirs()
	local dirs = {}
	local iterFn, dirObj = hs.fs.dir("/Volumes")
	if iterFn then
		for vol in iterFn, dirObj do
			if vol:sub(1, 1) ~= "." then
				table.insert(dirs, "/Volumes/" .. vol .. "/Applications")
				table.insert(dirs, "/Volumes/" .. vol .. "/Games")
			end
		end
	end
	return dirs
end

local cachedApps = {}
local lastRefresh = 0
local spotlightPaths = {} -- every app Spotlight knows about, filled in the background
local iconCache = {} -- path -> image, so rescanning does not reload icons

local MAX_DEPTH = 3 -- e.g. /Applications/DaVinci Resolve/DaVinci Resolve.app

-- Spotlight results that are not apps a person launches: nested helpers,
-- updaters, caches, downloads, build output, browser storage and so on.
local function wantedFromSpotlight(path)
	if not path:match("%.app$") then
		return false
	end
	if path:find("%.app/") then
		return false -- inside another app
	end
	for _, bad in ipairs({
		"/Downloads/", "/%.Trash", "/tmp/", "/Caches/", "/node_modules/", "/build/bin/",
		"/PrivateFrameworks/", "/CoreServices/", "/Application Scripts/", "/HTTPStorages/",
		"/storage/default/", "/Templates/", "/Updates?/", "/in_progress/", "/%.~%d+~/",
	}) do
		if path:find(bad) then
			return false
		end
	end
	-- Library folders hold helpers and updaters, except where games live
	if path:find("/Library/") and not path:find("/steamapps/common/", 1, true) then
		return false
	end
	return true
end

local function buildAppList()
	local apps = {}
	local seen = {}

	local function addApp(path)
		if seen[path] then
			return
		end
		seen[path] = true
		local name = path:match("([^/]+)%.app$")
		if not name then
			return
		end
		local image = iconCache[path]
		if image == nil then
			local info = hs.application.infoForBundlePath(path)
			if info and info.CFBundleIdentifier then
				image = hs.image.imageFromAppBundle(info.CFBundleIdentifier)
			end
			iconCache[path] = image or false
		end
		table.insert(apps, {
			text = name,
			subText = path,
			path = path,
			image = image or nil,
		})
	end

	-- walk subfolders too (Utilities, vendor folders, Chrome/Steam app folders),
	-- but never descend into .app bundles themselves
	local function scan(dir, depth)
		local iterFn, dirObj = hs.fs.dir(dir)
		if not iterFn then
			return
		end
		for file in iterFn, dirObj do
			if file:sub(1, 1) ~= "." then
				local path = dir .. "/" .. file
				if file:match("%.app$") then
					addApp(path)
				elseif depth < MAX_DEPTH and not file:match("%.bundle$") and hs.fs.attributes(path, "mode") == "directory" then
					scan(path, depth + 1)
				end
			end
		end
	end

	for _, dir in ipairs(appDirs) do
		scan(dir, 1)
	end
	for _, dir in ipairs(volumeDirs()) do
		scan(dir, 1)
	end
	for _, path in ipairs(spotlightPaths) do
		if wantedFromSpotlight(path) then
			addApp(path)
		end
	end
	addApp("/System/Library/CoreServices/Finder.app")

	table.sort(apps, function(a, b)
		return a.text:lower() < b.text:lower()
	end)
	return apps
end

local function refreshCache()
	cachedApps = buildAppList()
	lastRefresh = os.time()
end

-- Ask Spotlight for every application it has indexed, in the background, then
-- fold the result in. This is what finds apps installed anywhere else.
local spotlightTask = nil
local function refreshFromSpotlight()
	if spotlightTask and spotlightTask:isRunning() then
		return
	end
	spotlightTask = hs.task.new("/usr/bin/mdfind", function(exitCode, stdout)
		if exitCode ~= 0 or not stdout then
			return
		end
		local paths = {}
		for line in stdout:gmatch("[^\n]+") do
			table.insert(paths, line)
		end
		spotlightPaths = paths
		refreshCache()
	end, { "kMDItemContentType == 'com.apple.application-bundle'" })
	spotlightTask:start()
end

refreshCache()
refreshFromSpotlight()

-- rebuild the cache when an app is installed/removed/updated
local appDirWatchers = {}
for _, dir in ipairs(appDirs) do
	if hs.fs.attributes(dir, "mode") == "directory" then
		local watcher = hs.pathwatcher.new(dir, refreshCache)
		watcher:start()
		table.insert(appDirWatchers, watcher)
	end
end

-- Matching ignores case, spaces and punctuation, so "hollowknight silksong"
-- finds "Hollow Knight Silksong", and every typed word must appear somewhere
-- in the name (in any order).
local function compact(text)
	return (text:lower():gsub("[^%w\128-\255]", ""))
end

local function rank(app, query)
	local name = app.text:lower()
	local nameCompact = compact(app.text)
	local queryCompact = compact(query)
	if queryCompact == "" then
		return 3
	end
	if nameCompact:sub(1, #queryCompact) == queryCompact then
		return 1 -- starts with it
	end
	if nameCompact:find(queryCompact, 1, true) then
		return 2
	end
	for word in query:lower():gmatch("%S+") do
		if not name:find(word, 1, true) and not nameCompact:find(compact(word), 1, true) then
			return nil
		end
	end
	return 2
end

local function filtered(query)
	query = query or ""
	if query:match("^%s*$") then
		return cachedApps
	end
	local ranked = {}
	for i, app in ipairs(cachedApps) do
		local r = rank(app, query)
		if r then
			table.insert(ranked, { app = app, rank = r, index = i })
		end
	end
	table.sort(ranked, function(a, b)
		if a.rank ~= b.rank then
			return a.rank < b.rank
		end
		return a.index < b.index
	end)
	local out = {}
	for _, r in ipairs(ranked) do
		table.insert(out, r.app)
	end
	return out
end

-- Launched in the background with `open -a` (launchOrFocus blocks until the
-- app finishes launching, which kept the menu on screen for slow apps).
local function chooserSelected(choice)
	if choice then
		hs.task.new("/usr/bin/open", nil, { "-a", choice.path }):start()
	end
end

local CHOOSER_WIDTH_PERCENT = 20

local appChooser = hs.chooser.new(chooserSelected)
appChooser:searchSubText(false)
appChooser:width(CHOOSER_WIDTH_PERCENT)
appChooser:placeholderText("Open application...")
appChooser:queryChangedCallback(function(query)
	appChooser:choices(filtered(query))
end)

hs.hotkey.bind({ "cmd" }, "space", function()
	-- pick up apps installed since the last look (cheap: icons are cached)
	if os.time() - lastRefresh > 20 then
		refreshCache()
		refreshFromSpotlight()
	end
	appChooser:choices(cachedApps)
	menuPosition.showChooser(appChooser, CHOOSER_WIDTH_PERCENT)
end)
