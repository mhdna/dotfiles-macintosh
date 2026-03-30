-- hs
-- 	.loadSpoon("AppWindowSwitcher")
-- 	:setLogLevel("debug") -- uncomment for console debug log
-- 	:bindHotkeys({
-- 		["com.apple.Terminal"] = { cmd, "t" },
-- 		[{
-- 			"com.apple.Safari",
-- 			"com.google.Chrome",
-- 			"com.kagi.kagimacOS",
-- 			"com.microsoft.edgemac",
-- 			"org.mozilla.firefox",
-- 		}] = { cmd, "q" },
-- 		["Hammerspoon"] = { cmd, "h" },
-- 		[{ "O", "o" }] = { cmd, "o" },
-- 	})
--
--
--
-- ---------------------------------------------------------
-- APP SWITCHER FUNCTIONS - DO NOT EDIT THIS!
-- SCROLL DOWN TO THE KEYBOARD SHORTCUTS SECTION
-- ---------------------------------------------------------

local function cycleApplicationWindows(appObject)
	local visibleWindows = appObject:visibleWindows()
	local trulyVisibleWindows = {}

	for _, win in ipairs(visibleWindows) do
		local meetsCriteria = true
		if not win:isVisible() then
			meetsCriteria = false
		end

		if win:subrole() ~= "AXStandardWindow" then
			meetsCriteria = false
		end

		if meetsCriteria then
			table.insert(trulyVisibleWindows, win)
		end
	end

	if #trulyVisibleWindows <= 1 then
		return
	end

	table.sort(trulyVisibleWindows, function(a, b)
		return a:id() < b:id()
	end)

	local currentWindow = appObject:focusedWindow()
	local found = false

	for i, win in ipairs(trulyVisibleWindows) do
		if win:id() > currentWindow:id() then
			win:focus()
			found = true
			break
		end
	end

	if not found then
		trulyVisibleWindows[1]:focus()
	end
end

local function activateOrLaunch(bundleID)
	local frontmostApp = hs.application.frontmostApplication()

	if frontmostApp and frontmostApp:bundleID() == bundleID then
		cycleApplicationWindows(frontmostApp)
	else
		hs.application.launchOrFocusByBundleID(bundleID)
	end
end

local previousApp = nil
local function activateOrToggle(bundleID)
	local frontmostApp = hs.application.frontmostApplication()

	if frontmostApp and frontmostApp:bundleID() == bundleID then
		if previousApp then
			previousApp:activate()
		end
	else
		previousApp = frontmostApp
		hs.application.launchOrFocusByBundleID(bundleID)
	end
end

hs.hotkey.bind({ "alt" }, "w", function()
	activateOrToggle("org.mozilla.firefox")
end)

hs.hotkey.bind({ "alt" }, "f", function()
	activateOrToggle("com.microsoft.VSCode")
end)

hs.hotkey.bind({ "alt" }, "n", function()
	activateOrToggle("md.obsidian")
end)

-- hs.hotkey.bind({ "alt" }, "z", function()
-- 	activateOrToggle("dev.zed.Zed")
-- end)

hs.hotkey.bind({ "alt", "cmd" }, "c", function()
	activateOrToggle("org.hammerspoon.Hammerspoon")
end)

hs.hotkey.bind({ "alt", "shift" }, "w", function()
	activateOrToggle("com.brave.Browser")
end)

-- Switch to Messages by pressing Option+Enter
-- hs.hotkey.bind({ "alt" }, "e", function()
-- 	activateOrLaunch("org.gnu.Emacs")
-- end)

-- Switch to Messages by pressing Option+Enter
hs.hotkey.bind({ "alt" }, "t", function()
	-- activateOrLaunch("net.kovidgoyal.kitty")
	activateOrToggle("com.github.wez.wezterm")
end)

-- com.apple.MobileSMS

-- Switch to Apple Mail by pressing Command+F2
hs.hotkey.bind({ "cmd" }, "F2", function()
	activateOrLaunch("com.apple.mail")
end)

-- Switch to Passwords by pressing F3 without any modifiers
hs.hotkey.bind({}, "F3", function()
	activateOrLaunch("com.apple.Passwords")
end)

-- print current window bundle id
hs.hotkey.bind({ "alt", "shift" }, "c", function()
	-- copy it from clipboard
	hs.pasteboard.setContents(hs.application.frontmostApplication():bundleID())
	hs.alert.show(hs.application.frontmostApplication():bundleID())
end)
