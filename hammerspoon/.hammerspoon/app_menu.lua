-- cmd+space: small centered, searchable app launcher (Spotlight-style)
local menuPosition = require("menu_position")

local appDirs = {
	"/Applications",
	"/System/Applications",
	os.getenv("HOME") .. "/Applications",
}

local cachedApps = nil

local MAX_DEPTH = 3 -- e.g. /Applications/DaVinci Resolve/DaVinci Resolve.app

local function buildAppList()
	local apps = {}
	local seen = {}

	local function addApp(path)
		if seen[path] then
			return
		end
		seen[path] = true
		local name = path:match("([^/]+)%.app$")
		local image = nil
		local info = hs.application.infoForBundlePath(path)
		if info and info.CFBundleIdentifier then
			image = hs.image.imageFromAppBundle(info.CFBundleIdentifier)
		end
		table.insert(apps, {
			text = name,
			subText = path,
			path = path,
			image = image,
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
	addApp("/System/Library/CoreServices/Finder.app")

	table.sort(apps, function(a, b)
		return a.text:lower() < b.text:lower()
	end)
	return apps
end

local function refreshCache()
	cachedApps = buildAppList()
end

refreshCache()

-- rebuild the cache only when an app is installed/removed/updated, not on every open
local appDirWatchers = {}
for _, dir in ipairs(appDirs) do
	local watcher = hs.pathwatcher.new(dir, refreshCache)
	watcher:start()
	table.insert(appDirWatchers, watcher)
end

local function chooserSelected(choice)
	if choice then
		hs.application.launchOrFocus(choice.path)
	end
end

local CHOOSER_WIDTH_PERCENT = 20

local appChooser = hs.chooser.new(chooserSelected)
appChooser:searchSubText(false)
appChooser:width(CHOOSER_WIDTH_PERCENT)
appChooser:placeholderText("Open application...")

hs.hotkey.bind({ "cmd" }, "space", function()
	appChooser:choices(cachedApps)
	local screen = hs.screen.mainScreen():frame()
	local widthPx = screen.w * (CHOOSER_WIDTH_PERCENT / 100)
	appChooser:show(menuPosition.point(widthPx))
end)
