-- ctrl+cmd+… drives Mrec (~/Code/mac-utils/mrec), the menu-bar screen recorder.
-- Commands go to the app as mrec:// URLs; it reports back through
-- ~/Library/Application Support/Mrec/state.json, which we read for the alerts.
--
--   r  start / stop           p  pause / resume
--   m  mute / unmute mic      alt+s  mute / unmute system audio
--   v  record the screen or audio only   l  pick the save location
--   i  show what it's doing   w  open the Mrec window (vim keys)
--   shift+m / shift+s  whether the next recording takes the mic / system audio
--
-- Muting is live: the audio stays in the file as silence. The record
-- toggles (v, shift+m, shift+s) only change the next recording.

local BUNDLE = "com.mahdi.mrec"
local STATE = os.getenv("HOME") .. "/Library/Application Support/Mrec/state.json"

local function running()
	return hs.application.get(BUNDLE) ~= nil
end

local function clock(seconds)
	return string.format("%d:%02d", seconds // 60, seconds % 60)
end

local function describe(s)
	local label = { recording = "● Recording", paused = "‖ Paused", idle = "Mrec stopped" }
	local lines = { (label[s.state] or s.state) .. (s.state ~= "idle" and (" " .. clock(s.elapsed)) or "") }
	local inputs = {}
	if s.screen then table.insert(inputs, "screen") end
	if s.system then table.insert(inputs, "system audio" .. (s.muteSystem and " (muted)" or "")) end
	if s.mic then table.insert(inputs, "mic" .. (s.muteMic and " (muted)" or "")) end
	table.insert(lines, #inputs > 0 and table.concat(inputs, " + ") or "nothing selected")
	if s.status ~= "" then table.insert(lines, s.status) end
	return table.concat(lines, "\n")
end

local function report(delay)
	hs.timer.doAfter(delay or 0.3, function()
		local state = hs.json.read(STATE)
		if state then
			hs.alert.closeAll(0)
			hs.alert.show(describe(state), 1.2)
		end
	end)
end

-- launches: true for commands that make sense on an app that isn't running yet
local function send(path, launches)
	local wasRunning = running()
	if not wasRunning and not launches then
		hs.alert.show("Mrec isn't running", 0.6)
		return
	end
	hs.task.new("/usr/bin/open", nil, { "-g", "mrec://" .. path }):start()
	report(wasRunning and 0.3 or 1.5)
end

local function bind(mods, key, path, launches)
	hs.hotkey.bind(mods, key, function() send(path, launches) end)
end

local MODS = { "ctrl", "cmd" }
local MODS_SHIFT = { "ctrl", "cmd", "shift" }

bind(MODS, "r", "toggle", true)
bind(MODS, "p", "toggle-pause")
bind(MODS, "m", "toggle-mute/mic")
bind({ "ctrl", "cmd", "alt" }, "s", "toggle-mute/system") -- ctrl+cmd+s opens Mcam
bind(MODS, "v", "record/screen/toggle")
bind(MODS_SHIFT, "m", "record/mic/toggle")
bind(MODS_SHIFT, "s", "record/system/toggle")

hs.hotkey.bind(MODS, "w", function()
	hs.task.new("/usr/bin/open", nil, { "-g", "mrec://popup" }):start()
end)

hs.hotkey.bind(MODS, "i", function()
	if running() then report(0) else hs.alert.show("Mrec isn't running", 0.6) end
end)

hs.hotkey.bind(MODS, "l", function()
	local state = hs.json.read(STATE)
	local current = state and state.folder or (os.getenv("HOME") .. "/Movies/Mrec")
	hs.focus()
	local picked = hs.dialog.chooseFileOrFolder("Mrec save location", current, false, true, false)
	local path = picked and picked["1"]
	if path then
		send("folder?path=" .. hs.http.encodeForQuery(path), true)
		hs.alert.show("Saving to " .. (path:gsub("^" .. os.getenv("HOME"), "~")), 1.5)
	end
end)
