-- Reload config automatically
local configFileWatcher
function reloadConfig()
	configFileWatcher:stop()
	configFileWatcher = nil
	hs.reload()
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configFileWatcher:start()

-- all hs.alert.show(...) notifications: dark warm gray-brown (matches the
-- Driftwood browser theme), soft taupe border, warm off-white text
hs.alert.defaultStyle.fillColor = { red = 46 / 255, green = 41 / 255, blue = 37 / 255, alpha = 0.95 }
hs.alert.defaultStyle.strokeColor = { red = 120 / 255, green = 106 / 255, blue = 92 / 255, alpha = 0.9 }
hs.alert.defaultStyle.strokeWidth = 1.5
hs.alert.defaultStyle.textColor = { red = 232 / 255, green = 223 / 255, blue = 211 / 255, alpha = 1 }
hs.alert.defaultStyle.textSize = 20
hs.alert.defaultStyle.radius = 12
hs.alert.defaultStyle.padding = 18

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

local menuPosition = require("menu_position")

require("app_switcher")
require("move_windows")
require("toggle_apps")
require("per_app_tab_switch")
require("always_on_top")
require("kill_window")
require("app_menu")
require("quick_shell")
require("script_launcher")
require("time_tracker")
require("finder_redirect")

-- require("silent_alttab")

-- switch keyboard layout (replaces macOS's own opt+space switcher, which is buggy)
hs.hotkey.bind({ "alt" }, "space", function()
	local layouts = hs.keycodes.layouts()
	local current = hs.keycodes.currentLayout()
	local currentIndex = 1
	for i, layout in ipairs(layouts) do
		if layout == current then
			currentIndex = i
			break
		end
	end
	local nextIndex = (currentIndex % #layouts) + 1
	hs.keycodes.setLayout(layouts[nextIndex])
	hs.timer.doAfter(0.1, function()
		hs.alert.closeAll(0)
		hs.alert.show(hs.keycodes.currentLayout())
	end)
end)

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
		local quotedPath = "'" .. finderPath:gsub("'", "'\\''") .. "'"
		hs.execute("open -a Terminal " .. quotedPath)
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

-- Mission Control opened while a modifier is still held acts as "press and
-- hold to peek" and closes again as soon as the modifier is released, so a
-- quick tap aborts it mid-animation. Wait for the modifiers to come up first.
local function toggleMissionControlAfterRelease()
	hs.timer.waitUntil(function()
		local m = hs.eventtap.checkKeyboardModifiers()
		return not (m.alt or m.cmd or m.ctrl or m.shift)
	end, hs.spaces.toggleMissionControl, 0.01)
end

-- show mission control
hs.hotkey.bind({ "alt" }, "tab", toggleMissionControlAfterRelease)

-- opt+`: the same, all open windows at a glance
hs.hotkey.bind({ "alt" }, "`", toggleMissionControlAfterRelease)

hs.hotkey.bind({ "alt" }, "]", function()
	hs.spaces.goRight()
end)

hs.hotkey.bind({ "alt" }, "[", function()
	hs.spaces.goLeft()
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

-- -- Emacs/readline-style word jump (opt+b/opt+f), system-wide: macOS text
-- -- fields already treat opt+Left/opt+Right as word-back/word-forward, this
-- -- just aliases those two letter keys to the same arrow events.
-- hs.hotkey.bind({ "alt" }, "b", function()
-- 	hs.eventtap.keyStroke({ "alt" }, "left", 0)
-- end)
--
-- hs.hotkey.bind({ "alt" }, "f", function()
-- 	hs.eventtap.keyStroke({ "alt" }, "right", 0)
-- end)

local function pressSystemKey(key)
	hs.eventtap.event.newSystemKeyEvent(key, true):post()
	hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

-- volume controls (simulated media keys so the native macOS volume HUD shows)
hs.hotkey.bind({ "alt" }, "-", function()
	pressSystemKey("SOUND_DOWN")
end)

hs.hotkey.bind({ "alt" }, "=", function()
	pressSystemKey("SOUND_UP")
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

-- brightness controls (simulated media keys; BetterDisplay intercepts these
-- system-wide and adjusts the external display via DDC/CI)
hs.hotkey.bind({ "alt" }, ",", function()
	pressSystemKey("BRIGHTNESS_DOWN")
end)

hs.hotkey.bind({ "alt" }, ".", function()
	pressSystemKey("BRIGHTNESS_UP")
end)

-- global play/pause (simulated media key)
hs.hotkey.bind({ "cmd" }, "\\", function()
	pressSystemKey("PLAY")
end)

-- previous/next track (same as the macOS media rewind/fast-forward keys)
hs.hotkey.bind({ "cmd" }, "f11", function()
	pressSystemKey("REWIND")
end)

hs.hotkey.bind({ "cmd" }, "f12", function()
	pressSystemKey("FAST")
end)

-- cmd+shift+\ : list of currently-running, scriptable media players AND
-- browser tabs playing media; space toggles play/pause on whichever is
-- highlighted, without closing the list, so you can flip through several.
--
-- Browser tabs need one-time setup per browser (persists across restarts):
--   Brave:  View > Developer > Allow JavaScript from Apple Events
--   Safari: Develop > Allow JavaScript from Apple Events
-- Firefox has no AppleScript/JS-injection support, so its tabs can't be seen.
local mediaApps = {
	{ name = "Music", bundleID = "com.apple.Music" },
	{ name = "Spotify", bundleID = "com.spotify.client" },
	{ name = "TV", bundleID = "com.apple.TV" },
}

local browsers = {
	{ name = "Brave Browser", bundleID = "com.brave.Browser", dialect = "chromium" },
	{ name = "Google Chrome", bundleID = "com.google.Chrome", dialect = "chromium" },
	{ name = "Safari", bundleID = "com.apple.Safari", dialect = "safari" },
}

local MEDIA_CHECK_JS = [[(function(){
	var e = document.querySelectorAll('video,audio');
	for (var i = 0; i < e.length; i++) { if (!e[i].paused) return 'playing'; }
	for (var i = 0; i < e.length; i++) { if (e[i].currentTime > 0) return 'paused'; }
	return 'none';
})()]]

local MEDIA_TOGGLE_JS = [[(function(){
	var e = document.querySelectorAll('video,audio');
	for (var i = 0; i < e.length; i++) { if (!e[i].paused) { e[i].pause(); return 'paused'; } }
	for (var i = 0; i < e.length; i++) { if (e[i].currentTime > 0) { e[i].play(); return 'playing'; } }
	return 'none';
})()]]

local function playerState(appName)
	local ok, result =
		hs.osascript.applescript(string.format('tell application "%s" to return player state as string', appName))
	if ok then
		return result
	end
	return nil
end

local function togglePlayPause(appName)
	hs.osascript.applescript(string.format('tell application "%s" to playpause', appName))
end

-- One process launch per browser, total: enumerates every tab AND runs the
-- media-state JS check on each, all inside a single AppleScript run. Doing
-- this as N separate hs.osascript.applescript() calls (one per tab) used to
-- block Hammerspoon's single event-loop thread for seconds on end whenever
-- a browser had more than a handful of tabs open.
local function browserScanScript(browser)
	local titleProp = browser.dialect == "safari" and "name" or "title"
	local execute = browser.dialect == "safari" and 'do JavaScript "%s" in tab t of window w'
		or 'execute tab t of window w javascript "%s"'
	local js = MEDIA_CHECK_JS:gsub('"', '\\"'):gsub("\n", " ")
	return string.format([[
		tell application "%s"
			set AppleScript's text item delimiters to linefeed
			set outLines to {}
			repeat with w from 1 to (count of windows)
				repeat with t from 1 to (count of tabs of window w)
					set theState to "none"
					try
						set theState to (]] .. execute .. [[)
					end try
					if theState is not "none" then
						set end of outLines to (w as string) & "|" & (t as string) & "|" & theState & "|" & (%s of tab t of window w)
					end if
				end repeat
			end repeat
			return outLines as text
		end tell
	]], browser.name, js, titleProp)
end

-- Runs the given browser's scan asynchronously (via a plain osascript
-- subprocess, never blocking Hammerspoon) and calls back with a list of
-- {window, tab, title, state} for tabs currently playing or paused.
--
-- Hard-timed out: the very first time Hammerspoon sends an Apple Event to a
-- given browser, macOS may pop up a one-time "Hammerspoon wants to control
-- X" permission dialog. If that's never answered, the osascript subprocess
-- blocks forever — so we forcibly kill it after a few seconds rather than
-- let one stuck scan hang around indefinitely.
local function scanBrowserAsync(browser, callback)
	local handled = false
	local function finish(results)
		if handled then
			return
		end
		handled = true
		callback(results)
	end

	local task = hs.task.new("/usr/bin/osascript", function(exitCode, stdOut)
		local results = {}
		if exitCode == 0 and stdOut then
			for line in stdOut:gmatch("[^\r\n]+") do
				local w, t, state, title = line:match("^(%d+)|(%d+)|(%a+)|(.*)$")
				if w then
					table.insert(results, { window = tonumber(w), tab = tonumber(t), state = state, title = title })
				end
			end
		end
		finish(results)
	end, { "-e", browserScanScript(browser) })
	task:start()

	hs.timer.doAfter(4, function()
		if not handled and task:isRunning() then
			task:terminate()
			finish({})
		end
	end)
end

local function browserTabToggleScript(browser, window, tab)
	local js = MEDIA_TOGGLE_JS:gsub('"', '\\"'):gsub("\n", " ")
	if browser.dialect == "safari" then
		return string.format(
			'tell application "%s" to do JavaScript "%s" in tab %d of window %d',
			browser.name,
			js,
			tab,
			window
		)
	end
	return string.format(
		'tell application "%s" to execute tab %d of window %d javascript "%s"',
		browser.name,
		tab,
		window,
		js
	)
end

local function toggleSelected(selected)
	if selected.kind == "app" then
		togglePlayPause(selected.appName)
	elseif selected.kind == "tab" then
		local task = hs.task.new(
			"/usr/bin/osascript",
			nil,
			{ "-e", browserTabToggleScript(selected.browser, selected.window, selected.tab) }
		)
		task:start()
		hs.timer.doAfter(4, function()
			if task:isRunning() then
				task:terminate()
			end
		end)
	end
	-- flip locally rather than re-scanning everything, so the list doesn't
	-- reset scroll/selection every time you hit space
	selected.state = selected.state == "playing" and "paused" or "playing"
	if selected.kind == "app" then
		selected.subText = selected.state == "playing" and "▶ Playing — space to pause"
			or "⏸ Paused — space to play"
	elseif selected.kind == "tab" then
		selected.subText = (selected.state == "playing" and "▶ Playing — " or "⏸ Paused — ")
			.. selected.browser.name
			.. " — space to toggle"
	end
end

local function appChoices()
	local choices = {}
	for _, app in ipairs(mediaApps) do
		if hs.application.get(app.bundleID) then
			local state = playerState(app.name)
			if state then
				table.insert(choices, {
					text = app.name,
					subText = state == "playing" and "▶ Playing — space to pause" or "⏸ Paused — space to play",
					kind = "app",
					appName = app.name,
					state = state,
				})
			end
		end
	end
	return choices
end

-- Gathers app-based choices synchronously (fast, at most 3 calls) and calls
-- back immediately; browser tabs are scanned asynchronously afterwards and
-- merged in via a second callback invocation as each browser responds.
local function buildMediaChoicesAsync(onUpdate)
	local choices = appChoices()
	onUpdate(choices)

	local runningBrowsers = {}
	for _, browser in ipairs(browsers) do
		if hs.application.get(browser.bundleID) then
			table.insert(runningBrowsers, browser)
		end
	end

	for _, browser in ipairs(runningBrowsers) do
		scanBrowserAsync(browser, function(tabs)
			for _, tab in ipairs(tabs) do
				table.insert(choices, {
					text = tab.title,
					subText = (tab.state == "playing" and "▶ Playing — " or "⏸ Paused — ")
						.. browser.name
						.. " — space to toggle",
					kind = "tab",
					browser = browser,
					window = tab.window,
					tab = tab.tab,
					state = tab.state,
				})
			end
			onUpdate(choices)
		end)
	end
end

local mediaChooser = hs.chooser.new(function() end)
mediaChooser:width(30)
mediaChooser:placeholderText("Now playing...")

local mediaEventtap = nil
local currentMediaChoices = {}

local function stopMediaEventtap()
	if mediaEventtap then
		mediaEventtap:stop()
		mediaEventtap = nil
	end
end

mediaChooser:hideCallback(stopMediaEventtap)

hs.hotkey.bind({ "cmd", "shift" }, "\\", function()
	local initial = appChoices()
	currentMediaChoices = #initial == 0 and { { text = "Loading…", kind = "none" } } or initial
	mediaChooser:choices(currentMediaChoices)
	local screen = hs.screen.mainScreen():frame()
	mediaChooser:show(menuPosition.point(screen.w * 0.30))

	buildMediaChoicesAsync(function(choices)
		currentMediaChoices = #choices == 0 and { { text = "Nothing playing", kind = "none" } } or choices
		mediaChooser:choices(currentMediaChoices)
	end)

	stopMediaEventtap()
	mediaEventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
		if event:getKeyCode() == hs.keycodes.map["space"] then
			local idx = mediaChooser:selectedRow()
			local selected = currentMediaChoices[idx]
			if selected and selected.kind and selected.kind ~= "none" then
				toggleSelected(selected)
				-- update the entry in place instead of re-scanning everything,
				-- so the list doesn't jump/reset on every space press
				mediaChooser:choices(currentMediaChoices)
				mediaChooser:selectedRow(idx)
			end
			return true
		end
		return false
	end)
	mediaEventtap:start()
end)

-- switch default input (microphone) via a Spotlight-like chooser
local micChooser = hs.chooser.new(function(choice)
	if choice then
		hs.timer.doAfter(0, function() -- let the menu close first
			hs.audiodevice.findInputByName(choice.text):setDefaultInputDevice()
		end)
	end
end)
micChooser:width(20)
micChooser:rows(4)

hs.hotkey.bind({ "alt", "shift" }, "-", function()
	local currentUID = hs.audiodevice.defaultInputDevice():uid()
	local choices = {}
	local currentChoice = nil
	for _, dev in ipairs(hs.audiodevice.allInputDevices()) do
		local choice = {
			text = dev:name(),
			subText = dev:uid() == currentUID and "Current" or nil,
		}
		if dev:uid() == currentUID then
			currentChoice = choice
		else
			table.insert(choices, choice)
		end
	end
	if currentChoice then
		table.insert(choices, 1, currentChoice)
	end
	micChooser:choices(choices)
	local screen = hs.screen.mainScreen():frame()
	micChooser:show(menuPosition.point(screen.w * 0.20))
end)

-- switch default output (speakers/headphones) via a Spotlight-like chooser
local outputChooser = hs.chooser.new(function(choice)
	if choice then
		hs.timer.doAfter(0, function() -- let the menu close first
			hs.audiodevice.findOutputByName(choice.text):setDefaultOutputDevice()
		end)
	end
end)
outputChooser:width(20)
outputChooser:rows(4)

hs.hotkey.bind({ "alt", "shift" }, "=", function()
	local currentUID = hs.audiodevice.defaultOutputDevice():uid()
	local choices = {}
	local currentChoice = nil
	for _, dev in ipairs(hs.audiodevice.allOutputDevices()) do
		local choice = {
			text = dev:name(),
			subText = dev:uid() == currentUID and "Current" or nil,
		}
		if dev:uid() == currentUID then
			currentChoice = choice
		else
			table.insert(choices, choice)
		end
	end
	if currentChoice then
		table.insert(choices, 1, currentChoice)
	end
	outputChooser:choices(choices)
	local screen = hs.screen.mainScreen():frame()
	outputChooser:show(menuPosition.point(screen.w * 0.20))
end)

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
-- focus/launch lf-gui
hs.hotkey.bind({ "alt" }, "r", function()
	toggleApp("com.mahdi.lf-gui")
end)

-- disabled for now in favour of the vertical/horizontal toggles below
-- hs.hotkey.bind({ "alt" }, "m", function()
-- 	local win = hs.window.focusedWindow()
-- 	if win and win:isStandard() then
-- 		win:maximize()
-- 	end
-- end)

-- opt+m: toggle filling the screen's height; opt+shift+m: its width.
-- The other dimension stays put, and a second press restores the window.
local savedFrames = { vertical = {}, horizontal = {} }

local function toggleStretch(direction)
	local win = hs.window.focusedWindow()
	if not win or not win:isStandard() then
		return
	end
	local id = win:id()
	local frame = win:frame()
	local screen = win:screen():frame() -- excludes the menu bar and Dock
	-- Decide from the window's actual size, not from memory: resizing it by
	-- hand after stretching means the next press should stretch again.
	local close = function(a, b) return math.abs(a - b) <= 2 end
	local stretched
	if direction == "vertical" then
		stretched = close(frame.y, screen.y) and close(frame.h, screen.h)
	else
		stretched = close(frame.x, screen.x) and close(frame.w, screen.w)
	end

	local saved = savedFrames[direction][id]
	if stretched then
		if saved then
			win:setFrame(saved, 0)
		end
		savedFrames[direction][id] = nil
		return
	end
	savedFrames[direction][id] = frame:copy()
	if direction == "vertical" then
		frame.y, frame.h = screen.y, screen.h
	else
		frame.x, frame.w = screen.x, screen.w
	end
	win:setFrame(frame, 0)
end

hs.hotkey.bind({ "alt" }, "m", function()
	toggleStretch("vertical")
end)

hs.hotkey.bind({ "alt", "shift" }, "m", function()
	toggleStretch("horizontal")
end)

hs.alert.show("configuration reloaded", 0.3)

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

-- offline dictionary/translation popup for the selected word or sentence
-- (PopDefine runs as a resident background daemon via LaunchAgent; this just
-- signals it, avoiding the ~1s cold-start cost of relaunching the process)
hs.hotkey.bind({ "alt" }, "d", function()
	hs.task.new("/usr/bin/pkill", nil, { "-SIGUSR1", "-x", "PopDefine" }):start()
end)

-- live search mode: opens a search box, definitions update on every keystroke
hs.hotkey.bind({ "alt", "shift" }, "d", function()
	hs.task.new("/usr/bin/pkill", nil, { "-SIGUSR2", "-x", "PopDefine" }):start()
end)

-- toggle the saved-words browser window
hs.hotkey.bind({ "alt" }, "b", function()
	hs.task.new("/usr/bin/pkill", nil, { "-SIGINFO", "-x", "PopDefine" }):start()
end)

-- open the "add word" popup (type a word/phrase and pick a category)
hs.hotkey.bind({ "alt", "shift" }, "b", function()
	hs.task.new("/usr/bin/pkill", nil, { "-SIGURG", "-x", "PopDefine" }):start()
end)

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

-- Remap § key (ISO keycode 10) to ` (backtick); shift+§ to ~ (tilde).
-- Replaces the Karabiner rule that is no longer active. Keyboards like the
-- MX Keys Mini send keycode 10 for the key left of 1, so the down and up
-- events are mirrored one-for-one as ` with the held modifiers. A stray
-- keyUp (or a full keystroke fired on keyDown) makes cmd+` / opt+` hotkeys
-- misbehave, e.g. Mission Control starting to open and then aborting.
local eventTypes = hs.eventtap.event.types
tildeKeyTap = hs.eventtap.new({ eventTypes.keyDown, eventTypes.keyUp }, function(e)
	if e:getKeyCode() ~= 10 then
		return false
	end
	local flags = e:getFlags()
	local isDown = e:getType() == eventTypes.keyDown
	local isRepeat = e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) ~= 0
	-- Held hotkey combos shouldn't fire again on repeat; plain typing keeps it.
	if isDown and isRepeat and (flags.cmd or flags.alt or flags.ctrl) then
		return true
	end
	local mods = {}
	for _, m in ipairs({ "cmd", "alt", "ctrl", "shift", "fn" }) do
		if flags[m] then
			table.insert(mods, m)
		end
	end
	hs.eventtap.event.newKeyEvent(mods, "`", isDown):post()
	return true
end)
tildeKeyTap:start()

-- ctrl+opt+r: reload the Hammerspoon config. If Hammerspoon itself stops, the
-- LaunchAgent com.mahdi.hammerspoon-keepalive starts it again within ~10 s.
hs.hotkey.bind({ "ctrl", "alt" }, "r", function()
	hs.reload()
end)

-- open or focus lf-gui (~/Code/mac-utils/lf-gui)
hs.hotkey.bind({ "alt" }, "f", function()
	hs.application.launchOrFocusByBundleID("com.mahdi.lf-gui")
end)

-- open or focus mxiv (~/Code/mac-utils/mxiv); launched bare it shows ~/Pictures
hs.hotkey.bind({ "alt" }, "p", function()
	hs.application.launchOrFocusByBundleID("com.mahdi.mxiv")
end)

-- open or focus VED, the vim-style text editor (~/Code/mac-utils/ved)
hs.hotkey.bind({ "alt" }, "v", function()
	hs.application.launchOrFocusByBundleID("com.mahdi.ved")
end)

-- bring every open mpv window to the front (never launches mpv)
hs.hotkey.bind({ "alt", "shift" }, "p", function()
	local mpv = hs.application.get("mpv")
	if not mpv then
		hs.alert.show("mpv isn't running", 0.6)
		return
	end
	for _, win in ipairs(mpv:allWindows()) do
		if win:isMinimized() then
			win:unminimize()
		end
	end
	mpv:activate(true) -- true: raise all of its windows, not just the main one
end)

-- cmd+shift+q: put the Mac to sleep (replaces macOS's Log Out shortcut)
hs.hotkey.bind({ "cmd", "shift" }, "q", function()
	hs.caffeinate.systemSleep()
end)
