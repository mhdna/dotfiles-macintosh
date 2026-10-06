-- cmd+space: small centered, searchable app launcher (Spotlight-style)
local menuPosition = require("menu_position")

local appDirs = {
	"/Applications",
	"/System/Applications",
	"/System/Applications/Utilities",
	os.getenv("HOME") .. "/Applications",
}

local cachedApps = nil

local function buildAppList()
	local apps = {}
	local seen = {}

	for _, dir in ipairs(appDirs) do
		local iterFn, dirObj = hs.fs.dir(dir)
		if iterFn then
			for file in iterFn, dirObj do
				if file:match("%.app$") then
					local path = dir .. "/" .. file
					if not seen[path] then
						seen[path] = true
						local name = file:gsub("%.app$", "")
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
				end
			end
		end
	end

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
