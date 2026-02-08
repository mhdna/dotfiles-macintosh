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
require("silent_alttab")

-- switch keyboard layout
hs.hotkey.bind({ "alt" }, "space", function()
	local layouts = hs.keycodes.layouts()
	local current = hs.keycodes.currentSourceID()
	local currentIndex = hs.fnutils.indexOf(layouts, current) or 1
	local nextIndex = (currentIndex % #layouts) + 1
	hs.keycodes.currentSourceID(layouts[nextIndex])
	hs.alert.show(hs.keycodes.currentLayout())
end)

-- show mission control
hs.hotkey.bind({ "alt" }, "escape", function()
	hs.spaces.toggleMissionControl()
end)

-- volume controls
hs.hotkey.bind({ "alt" }, "-", function()
	hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.current().volume - 5)
end)

-- mute toggle
hs.hotkey.bind({ "alt", "shift" }, "-", function()
	local device = hs.audiodevice.defaultOutputDevice()
	device:setMuted(not device:muted())
	if device:muted() then
		hs.alert.show("Muted")
	else
		hs.alert.show("Unmuted")
	end
end)

hs.hotkey.bind({ "alt" }, "=", function()
	hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.current().volume + 5)
end)

-- brightness controls
hs.hotkey.bind({ "alt" }, ",", function()
	hs.brightness.set(hs.brightness.get() - 5)
end)

hs.hotkey.bind({ "alt" }, ".", function()
	hs.brightness.set(hs.brightness.get() + 5)
end)

-- simple_switcher = require("simple_switcher")
-- switcher = simple_switcher.new({ title_width = 1000, item_height = 32 })
-- local function mapAltTab(event)
-- 	local flags = event:getFlags()
-- 	local chars = event:getCharacters()
-- 	if chars == "\t" and flags:containExactly({ "cmd" }) then
-- 		switcher:next()
-- 		return true
-- 	elseif chars == string.char(25) and flags:containExactly({ "cmd", "shift" }) then
-- 		switcher:previous()
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
hs.alert.show("configuration reloaded", 0.3)
