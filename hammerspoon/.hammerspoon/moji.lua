-- ctrl+cmd+space: Moji (~/Code/mac-utils/moji), a fast emoji picker in place of macOS's own.
-- Moji stays running in the background so it opens instantly; this just pokes it with a
-- distributed notification (with the caret's position, so it opens under the text you're
-- typing), and pastes back whatever it hands over when it closes.
--
--   type to search (forgiving), ctrl+n/p/f/b to move, return adds an emoji,
--   ctrl+c closes and inserts them all, esc closes without inserting.

local BUNDLE = "com.mahdi.moji"

local function ensureRunning(show)
	if hs.application.get(BUNDLE) then
		return true
	end
	local args = { "-g", "-b", BUNDLE }
	if show then
		table.insert(args, "--args")
		table.insert(args, "--show")
	end
	hs.task.new("/usr/bin/open", nil, args):start()
	return false
end

local function rect(r)
	if r and r.w and r.h and (r.w > 0 or r.h > 0) and r.x and r.y then
		return r
	end
end

-- Where the text caret is, so the picker opens right under it: the selection's bounds when the
-- app reports them, else the focused field itself (when it's field-sized), else the window.
local function caretRect()
	local system = hs.axuielement.systemWideElement()
	system:setTimeout(0.15)
	local el = system:attributeValue("AXFocusedUIElement")
	if el then
		el:setTimeout(0.15)
		local range = el:attributeValue("AXSelectedTextRange")
		if range then
			local r = rect(el:parameterizedAttributeValue("AXBoundsForRange", { location = range.location, length = 0 }))
			if r and r.h < 200 then
				return r
			end
		end
		local f = rect(el:attributeValue("AXFrame"))
		if f and f.h < 120 then
			return f
		end
	end
	local win = hs.window.focusedWindow()
	if win then
		local f = win:frame()
		return { x = f.x + f.w / 2 - 240, y = f.y + f.h * 0.25, w = 0, h = 0 }
	end
end

hs.hotkey.bind({ "ctrl", "cmd" }, "space", function()
	if not ensureRunning(true) then
		return
	end
	local ok, r = pcall(caretRect)
	local where = nil
	if ok and r then
		where = string.format("%d,%d,%d,%d", r.x, r.y, r.w, r.h)
	end
	hs.distributednotifications.post("com.mahdi.moji.toggle", where)
end)

-- Moji closes on ctrl+c: wait for ctrl to come up and focus to settle back in the field, then
-- paste the emojis (keystrokes with emoji in them are dropped by terminals like Alacritty).
-- The clipboard is put back afterwards and the paste is marked transient, so clipboard
-- managers skip it.
local function paste(text)
	local saved = hs.pasteboard.readAllData()
	hs.pasteboard.setContents(text)
	pcall(hs.pasteboard.writeDataForUTI, "Apple CFPasteboard general", "org.nspasteboard.TransientType", "", true)
	hs.eventtap.keyStroke({ "cmd" }, "v", 0)
	hs.timer.doAfter(0.5, function()
		if saved and next(saved) then
			hs.pasteboard.writeAllData(saved)
		end
	end)
end

local insertWatcher = hs.distributednotifications.new(function(_, text)
	if type(text) ~= "string" or text == "" then
		return
	end
	hs.timer.waitUntil(function()
		local m = hs.eventtap.checkKeyboardModifiers()
		return not (m.alt or m.cmd or m.ctrl or m.shift)
	end, function()
		paste(text)
	end, 0.01)
end, "com.mahdi.moji.insert")
insertWatcher:start()

-- start it with Hammerspoon so the first ctrl+cmd+space is instant too
ensureRunning(false)

return { watcher = insertWatcher }
