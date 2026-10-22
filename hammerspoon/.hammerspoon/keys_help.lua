-- opt+/ : a help window listing every Hammerspoon hotkey, in groups, like
-- awesome wm's hotkeys popup. Any key (opt+/ too) or a click closes it, and
-- it never takes focus from the window you're in.
--
-- Loaded first in init.lua: it wraps hs.hotkey.bind to record every binding
-- as the other modules make them, so the window always shows what's really
-- bound. Bindings described in GROUPS below appear under their group; any
-- other binding still shows up, under "Other", so nothing goes missing.

local M = {}

local recorded = {} -- "alt+shift+e" -> true, for every bound hotkey
local MOD_ORDER = { "ctrl", "alt", "shift", "cmd" }

local function normalize(mods, key)
	local set = {}
	for _, m in ipairs(mods or {}) do
		m = m:lower()
		if m == "option" or m == "⌥" then m = "alt" end
		if m == "command" or m == "⌘" then m = "cmd" end
		if m == "control" or m == "⌃" then m = "ctrl" end
		set[m] = true
	end
	local parts = {}
	for _, m in ipairs(MOD_ORDER) do
		if set[m] then table.insert(parts, m) end
	end
	table.insert(parts, tostring(key):lower())
	return table.concat(parts, "+")
end

local originalBind = hs.hotkey.bind
hs.hotkey.bind = function(mods, key, ...)
	recorded[normalize(mods, key)] = true
	return originalBind(mods, key, ...)
end

-- Each entry: { mods, key or {keys…}, description }.
local GROUPS = {
	{ "Apps (press again to go back)", "#82d4fc", {
		{ { "alt" }, "t", "Alacritty" },
		{ { "alt" }, "w", "Brave" },
		{ { "alt" }, "r", "LFGUI" },
		{ { "alt" }, "v", "VED" },
		{ { "alt" }, "p", "MXIV" },
		{ { "alt" }, "c", "Claude" },
		{ { "alt" }, "a", "WhatsApp" },
		{ { "alt" }, "n", "Obsidian" },
		{ { "alt", "shift" }, "i", "Discord" },
		{ { "alt", "shift" }, "v", "OBS" },
		{ { "alt" }, "s", "System Settings" },
		{ { "alt" }, "g", "QuickTime" },
		{ { "cmd" }, "f2", "Mail" },
		{ {}, "f3", "Passwords" },
		{ { "alt", "shift" }, "p", "bring mpv windows forward" },
	} },
	{ "Launchers & menus", "#f0c049", {
		{ { "cmd" }, "space", "app launcher" },
		{ { "ctrl" }, "space", "quick shell command" },
		{ { "cmd", "shift" }, "space", "find files (recent first)" },
		{ { "alt", "shift" }, "s", "run a script" },
		{ { "cmd", "shift" }, "\\", "now playing (space toggles)" },
		{ { "ctrl", "alt" }, "-", "pick microphone" },
		{ { "ctrl", "alt" }, "=", "pick speakers" },
		{ { "alt" }, "/", "this help" },
	} },
	{ "Windows & spaces", "#82d46a", {
		{ { "alt" }, { "h", "j", "k", "l" }, "move window" },
		{ { "alt", "shift" }, { "h", "j", "k", "l" }, "resize window" },
		{ { "alt" }, "m", "stretch to full height" },
		{ { "alt", "shift" }, "m", "stretch to full width" },
		{ { "alt", "shift" }, "f", "full screen" },
		{ { "cmd" }, "`", "next window of this app" },
		{ { "alt" }, "\\", "cycle this app's windows" },
		{ { "alt", "shift" }, "\\", "cycle back" },
		{ { "alt" }, { "tab", "`" }, "Mission Control" },
		{ { "alt" }, { "[", "]" }, "previous / next space" },
		{ { "ctrl", "cmd" }, "t", "keep window on top" },
		{ { "ctrl", "cmd" }, "x", "kill an app: click its window" },
	} },
	{ "Media & system", "#e83662", {
		{ { "alt" }, { "-", "=" }, "volume down / up" },
		{ { "alt" }, { ",", "." }, "brightness down / up" },
		{ { "cmd" }, "\\", "play / pause" },
		{ { "cmd" }, { "f11", "f12" }, "previous / next track" },
		{ { "alt" }, "space", "switch keyboard layout" },
		{ { "cmd", "shift" }, "q", "sleep" },
	} },
	{ "Words (PopDefine)", "#a888fa", {
		{ { "alt" }, "e", "define the selection" },
		{ { "alt", "shift" }, "e", "live search" },
		{ { "alt", "shift" }, "w", "saved words" },
		{ { "alt", "shift" }, "b", "add a word" },
	} },
	{ "Obsidian time tracker", "#4fd8ff", {
		{ { "ctrl", "alt" }, "s", "start / stop" },
		{ { "ctrl", "alt" }, "t", "pick a card" },
		{ { "ctrl", "alt" }, "p", "pause / resume" },
		{ { "ctrl", "alt" }, "d", "finish card" },
		{ { "ctrl", "alt" }, "j", "open its board" },
	} },
	{ "Screen recorder (Mrec)", "#ff6b6b", {
		{ { "ctrl", "cmd" }, "r", "start / stop" },
		{ { "ctrl", "cmd" }, "p", "pause / resume" },
		{ { "ctrl", "cmd" }, "m", "mute / unmute mic" },
		{ { "ctrl", "cmd", "alt" }, "s", "mute / unmute system audio" },
		{ { "ctrl", "cmd" }, "v", "record screen / audio only" },
		{ { "ctrl", "cmd", "shift" }, "m", "next recording: mic on / off" },
		{ { "ctrl", "cmd", "shift" }, "s", "next recording: system audio on / off" },
		{ { "ctrl", "cmd" }, "l", "pick the save location" },
		{ { "ctrl", "cmd" }, "i", "show recorder status" },
		{ { "ctrl", "cmd" }, "w", "open the recorder window (vim keys)" },
	} },
	{ "Audio sharing (Mmix)", "#5ad1a0", {
		{ { "ctrl", "cmd" }, "a", "open the Mmix window (vim keys)" },
	} },
	{ "Virtual camera (Mcam)", "#7be0a0", {
		{ { "ctrl", "cmd" }, "s", "pick a screen or window to share (vim keys)" },
		{ { "ctrl", "cmd" }, { "-", "=" }, "zoom out / in" },
	} },
	{ "Claude accounts (Mclaude)", "#d97757", {
		{ { "ctrl", "cmd" }, "c", "open the accounts window (vim keys)" },
		{ { "ctrl", "cmd", "shift" }, "c", "switch to the next account" },
	} },
	{ "App time limits (Morganize)", "#e07a4f", {
		{ { "ctrl", "cmd" }, "o", "open Morganize (vim keys)" },
	} },
	{ "Hammerspoon & misc", "#d0d0d0", {
		{ { "ctrl", "alt" }, "r", "reload Hammerspoon" },
		{ { "ctrl", "alt" }, "f", "Finder → LFGUI redirect on/off" },
		{ { "cmd", "alt" }, "t", "Terminal at Finder's folder" },
		{ { "cmd", "alt" }, "r", "auto-press F+X on/off" },
	} },
}

local MOD_SYMBOL = { ctrl = "⌃", alt = "⌥", shift = "⇧", cmd = "⌘" }
local KEY_NAME = {
	["return"] = "↩", space = "Space", tab = "⇥", escape = "⎋", delete = "⌫",
	left = "←", right = "→", up = "↑", down = "↓",
}

local function label(combo)
	local out = {}
	local parts = {}
	for p in combo:gmatch("[^+]+") do table.insert(parts, p) end
	local key = table.remove(parts)
	for _, m in ipairs(parts) do table.insert(out, MOD_SYMBOL[m] or m) end
	local name = KEY_NAME[key] or (key:match("^f%d+$") and key:upper()) or key:upper()
	return table.concat(out) .. name
end

local function escape(s)
	return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function buildHTML()
	local described = {}
	local html = {}
	for _, group in ipairs(GROUPS) do
		local title, color, entries = group[1], group[2], group[3]
		local rows = {}
		for _, e in ipairs(entries) do
			local keys = type(e[2]) == "table" and e[2] or { e[2] }
			local labels = {}
			for _, k in ipairs(keys) do
				local combo = normalize(e[1], k)
				described[combo] = true
				if recorded[combo] then table.insert(labels, label(combo)) end
			end
			if #labels > 0 then
				table.insert(rows, string.format('<div class="row"><span class="keys">%s</span><span class="desc">%s</span></div>',
					escape(table.concat(labels, " ")), escape(e[3])))
			end
		end
		if #rows > 0 then
			table.insert(html, string.format('<section><h2 style="color:%s">%s</h2>%s</section>', color, escape(title), table.concat(rows)))
		end
	end
	local others = {}
	for combo in pairs(recorded) do
		if not described[combo] then table.insert(others, combo) end
	end
	if #others > 0 then
		table.sort(others)
		local rows = {}
		for _, combo in ipairs(others) do
			table.insert(rows, string.format('<div class="row"><span class="keys">%s</span><span class="desc dim">no description yet</span></div>', escape(label(combo))))
		end
		table.insert(html, '<section><h2 style="color:#6c6c6c">Other</h2>' .. table.concat(rows) .. "</section>")
	end

	return [[<!doctype html><html><head><meta charset="utf-8"><style>
html, body { margin: 0; height: 100%; background: #1c1c1c; color: #e8e6e1;
  font: 14px/1.5 "Comic Mono", ui-monospace, Menlo, monospace; -webkit-user-select: none; cursor: default; }
body { box-sizing: border-box; padding: 22px 28px; border: 2px solid #3a3a3a; overflow: auto; }
header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 14px;
  border-bottom: 1px solid #3a3a3a; padding-bottom: 8px; }
header h1 { margin: 0; font-size: 16px; color: #ffffff; }
header span { color: #6c6c6c; font-size: 12px; }
main { column-count: 3; column-gap: 34px; }
section { break-inside: avoid; margin: 0 0 18px; }
h2 { margin: 0 0 6px; font-size: 14px; }
.row { display: flex; gap: 14px; padding: 1px 0; }
.keys { flex: 0 0 auto; min-width: 7.5em; color: #f0c049; white-space: nowrap; }
.desc { color: #e8e6e1; }
.dim { color: #6c6c6c; }
</style></head><body><header><h1>Hammerspoon keys</h1><span>esc / ⌥/ / click to close</span></header><main>]]
		.. table.concat(html) .. [[</main></body></html>]]
end

local view, previous, keyTap, clickTap

-- The window never takes focus: while it's up, Hammerspoon itself watches
-- for a key (which closes it and is swallowed) or a click (which closes it
-- and still goes through). Whatever you were in stays focused; it's also
-- re-focused on close, in case anything stole it.
local function hide()
	if keyTap then keyTap:stop(); keyTap = nil end
	if clickTap then clickTap:stop(); clickTap = nil end
	if view then
		view:delete()
		view = nil
	end
	if previous and previous:application() then previous:focus() end
	previous = nil
end

local MODIFIER_KEYS = { [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true,
	[60] = true, [61] = true, [62] = true, [63] = true } -- cmd, shift, caps, alt, ctrl, fn

function M.toggle()
	if view then
		hide()
		return
	end
	previous = hs.window.focusedWindow()
	local screen = hs.screen.mainScreen():frame()
	local w, h = math.min(1180, screen.w * 0.86), math.min(760, screen.h * 0.82)
	local rect = { x = screen.x + (screen.w - w) / 2, y = screen.y + (screen.h - h) / 2, w = w, h = h }

	view = hs.webview.new(rect, { developerExtrasEnabled = false })
		:windowStyle({ "borderless", "nonactivating" })
		:level(hs.drawing.windowLevels.modalPanel)
		:shadow(true)
		:html(buildHTML())
		:show()

	keyTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
		if MODIFIER_KEYS[event:getKeyCode()] then return false end
		hs.timer.doAfter(0, hide)
		return true -- the key only closes the help
	end)
	keyTap:start()
	clickTap = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown, hs.eventtap.event.types.rightMouseDown }, function()
		hs.timer.doAfter(0, hide)
		return false
	end)
	clickTap:start()
end

hs.hotkey.bind({ "alt" }, "/", M.toggle)

return M
