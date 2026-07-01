-- Reload config automatically
local configFileWatcher
function reloadConfig()
	configFileWatcher:stop()
	configFileWatcher = nil
	hs.reload()
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configFileWatcher:start()

-- ---------------------------------------------------------
-- KEYBOARD SHORTCUTS SECTION
--
-- General schema:
--
-- hs.hotkey.bind({MODIFIERS}, KEYCODE, function ()
--   activateOrLaunch(BUNDLE IDENTIFIER)
-- end)
--
-- Available MODIFIERS:
-- - "ctrl" - Control key
-- - "alt" - Option key
-- - "cmd" - Command key
-- - "shift" - Shift key
--
--
-- YOUR KEYBOARD SHORTCUTS GOES HERE
-- FEEL FREE TO MODIFY THIS:
-- ---------------------------------------------------------

require("app_switcher")
require("move_windows")
require("toggle_apps")
require("per_app_tab_switch")

-- require("silent_alttab")

-- -- switch keyboard layout
-- hs.hotkey.bind({ "ctrl" }, "space", function()
-- 	local current = hs.keycodes.currentLayout()
-- 	if current == "ABC" then
-- 		hs.keycodes.setLayout("Arabic - PC")
-- 	else
-- 		hs.keycodes.setLayout("ABC")
-- 	end
-- 	hs.timer.doAfter(0.1, function()
-- 		hs.alert.show(hs.keycodes.currentLayout())
-- 	end)
-- end)

hs.hotkey.bind({ "cmd", "alt" }, "T", function()
	local finderPath = hs.osascript.applescript([[
        tell application "Finder"
           try
                set thePath to (POSIX path of (target of front window as alias))
            on error
                set thePath to (POSIX path of (desktop as alias))
            end try
        end tell
        return thePath
    ]])
	if finderPath then
		hs.execute("open -a Terminal " .. finderPath)
	end
end)

hs.hotkey.bind({ "cmd" }, "`", function()
	local app = hs.application.frontmostApplication()
	local windows = app:allWindows()

	if #windows > 1 then
		local focused = hs.window.focusedWindow()
		for i, w in ipairs(windows) do
			if w == focused then
				windows[(i % #windows) + 1]:focus()
				return
			end
		end
	end
end)

-- show mission control
hs.hotkey.bind({ "alt" }, "tab", function()
	hs.spaces.toggleMissionControl()
end)

hs.hotkey.bind({ "alt" }, "]", function()
	hs.spaces.goRight()
end)

hs.hotkey.bind({ "alt" }, "[", function()
	hs.spaces.goRight()
end)

-- -- wait for internet
-- hs.hotkey.bind({ "alt" }, "i", function()
-- 	hs.alert.show("🐻Waiting...", 1)
-- 	hs.timer.doUntil(
-- 		function() -- condition: internet is back
-- 			local result = hs.execute("ping -c 1 -t 1 8.8.8.8 > /dev/null 2>&1")
-- 			return result == true
-- 		end,
-- 		function() -- action while waiting: do nothing
-- 		end,
-- 		1 -- check every 1 second
-- 	)
-- 	hs.timer.doAfter(0, function()
-- 		hs.alert.show("🔴Internet is Back", 1)
-- 	end)
-- end)

hs.hotkey.bind({ "alt", "shift" }, "f", function()
	local win = hs.window.focusedWindow()
	if win then
		win:toggleFullScreen()
	end
end)

-- volume controls
hs.hotkey.bind({ "alt" }, "-", function()
	hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.current().volume - 5)
end)

-- -- mute toggle
-- hs.hotkey.bind({ "alt", "shift" }, "-", function()
-- 	local device = hs.audiodevice.defaultOutputDevice()
-- 	device:setMuted(not device:muted())
-- 	if device:muted() then
-- 		hs.alert.show("Muted")
-- 	else
-- 		hs.alert.show("Unmuted")
-- 	end
-- end)

-- hs.hotkey.bind({ "alt" }, "=", function()
-- 	hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.current().volume + 5)
-- end)

-- -- brightness controls
-- hs.hotkey.bind({ "alt" }, ",", function()
-- 	hs.brightness.set(hs.brightness.get() - 5)
-- end)

-- hs.hotkey.bind({ "alt" }, ".", function()
-- 	hs.brightness.set(hs.brightness.get() + 5)
-- end)

-- simple_switcher = require("simple_switcher")
-- switcher = simple_switcher.new({ title_width = 1000, item_height = 32 })
-- local function mapAltTab(event)
-- 	local flags = event:getFlags()
-- 	local chars = event:getCharacters()
-- 	if chars == "\t" and flags:containExactly({ "cmd" }) then
-- 		-- switcher:next()
-- 		return true
-- 	elseif chars == string.char(25) and flags:containExactly({ "cmd", "shift" }) then
-- 		-- switcher:previous()
-- 		return true
-- 	end
-- end
-- tapAltTab = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, mapAltTab)
-- tapAltTab:start()

-- Finally, show a notification that we finished loading the config
-- hs.notify.new({ title = "Hammerspoon", subTitle = "Configuration loaded" }):send()
-- hs.alert.showWithImage(
-- 	"configuration reloaded",
-- 	hs.image.imageFromPath("~/Pictures/hammer-spoon-image.jpg"):setSize({ w = 100, h = 100 })
-- )
--

-- hs.hotkey.bind({ "alt" }, "m", function()
-- 	local wins = hs.window.visibleWindows()
-- 	for _, win in ipairs(wins) do
-- 		if win:isStandard() then
-- 			win:maximize()
-- 		end
-- 	end
-- end)
hs.hotkey.bind({ "alt" }, "m", function()
	local win = hs.window.focusedWindow()
	if win and win:isStandard() then
		win:maximize()
	end
end)

hs.alert.show("configuration reloaded", 0.3)

local isRunning = false
local timer = nil

local isRunning = false
local timer = nil

function pressFX()
	local fDown = hs.eventtap.event.newKeyEvent({}, "f", true)
	local xDown = hs.eventtap.event.newKeyEvent({}, "x", true)

	local fUp = hs.eventtap.event.newKeyEvent({}, "f", false)
	local xUp = hs.eventtap.event.newKeyEvent({}, "x", false)

	-- press both keys down
	fDown:post()
	xDown:post()

	-- release shortly after
	hs.timer.doAfter(0.02, function()
		fUp:post()
		xUp:post()
	end)
end

hs.hotkey.bind({ "cmd", "alt" }, "R", function()
	if isRunning then
		if timer then
			timer:stop()
			timer = nil
		end
		isRunning = false
		hs.alert.show("stopped", 0.3)
	else
		timer = hs.timer.doEvery(0.05, pressFX)
		isRunning = true
		hs.alert.show("started", 0.3)
	end
end)
