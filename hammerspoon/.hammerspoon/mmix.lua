-- ctrl+cmd+… drives Mmix (~/Code/mac-utils/mmix), the menu-bar app that sends the
-- computer's audio and the microphone to BlackHole, so a call hears both.
-- Commands go to the app as mmix:// URLs; it reports back through
-- ~/Library/Application Support/Mmix/state.json, which we read for the alerts.
--
--   Only a is bound for now (everything else is done from the window); the rest are
--   commented out at the bottom and work again if you uncomment them.
--   a  open / close the Mmix window (three columns; vim keys: j/k, h/l, tab, ⏎, s, m, c, o, n, e, q)
--   shift+a  start / stop sharing    d  mute / unmute computer audio
--   n  mute / unmute mic             o  share only the selected apps on / off
--   h  hear your own mic (monitor) on / off
--   =  /  -  mic volume up / down      ]  /  [  computer volume up / down
--   u  noise suppression on / off

local BUNDLE = "com.mahdi.mmix"
local STATE = os.getenv("HOME") .. "/Library/Application Support/Mmix/state.json"

local function describe(s)
	local lines = { s.running and "● Sharing audio" or "Mmix stopped" }
	table.insert(lines, "computer audio " .. (s.system and "on" or "muted") .. (s.only and " (selected apps only)" or ""))
	table.insert(lines, "mic " .. (s.mic and "on" or "muted") .. (s.monitor and " (monitoring)" or ""))
	if s.noise then table.insert(lines, "noise suppression on") end
	if s.gain and s.gain ~= 1 then table.insert(lines, "mic volume ×" .. s.gain) end
	if s.systemGain and s.systemGain ~= 1 then table.insert(lines, "computer volume ×" .. s.systemGain) end
	if s.error ~= "" then table.insert(lines, s.error) end
	return table.concat(lines, "\n")
end

local function report(delay)
	hs.timer.doAfter(delay, function()
		local state = hs.json.read(STATE)
		if state then
			hs.alert.closeAll(0)
			hs.alert.show(describe(state), 1.2)
		end
	end)
end

local function send(path, launches)
	local wasRunning = hs.application.get(BUNDLE) ~= nil
	if not wasRunning and not launches then
		hs.alert.show("Mmix isn't running", 0.6)
		return
	end
	hs.task.new("/usr/bin/open", nil, { "-g", "mmix://" .. path }):start()
	report(wasRunning and 0.5 or 2)
end

local MODS = { "ctrl", "cmd" }

hs.hotkey.bind(MODS, "a", function()
	hs.task.new("/usr/bin/open", nil, { "-g", "mmix://popup" }):start()
end)
-- hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "a", function() send("toggle", true) end)
-- hs.hotkey.bind(MODS, "d", function() send("toggle-system") end)
-- hs.hotkey.bind(MODS, "n", function() send("toggle-mic") end)
-- hs.hotkey.bind(MODS, "o", function() send("toggle-only") end)
-- hs.hotkey.bind(MODS, "h", function() send("toggle-monitor") end)
-- hs.hotkey.bind(MODS, "u", function() send("toggle-noise") end)
-- hs.hotkey.bind(MODS, "=", function() send("gain-up") end)
-- hs.hotkey.bind(MODS, "-", function() send("gain-down") end)
-- hs.hotkey.bind(MODS, "]", function() send("system-up") end)
-- hs.hotkey.bind(MODS, "[", function() send("system-down") end)
