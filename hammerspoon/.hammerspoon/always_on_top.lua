-- Cmd+Ctrl+T toggles always-on-top for the focused window. Any number of
-- windows can be pinned; each gets a 📌 badge on its title bar, and
-- clicking the badge unpins it.
--
-- macOS has no public API for changing another app's window level, so this
-- goes through yabai's scripting addition: yabai must be running with SIP
-- partially disabled and `sudo yabai --load-sa` done (see yabairc).
local yabai = "/opt/homebrew/bin/yabai"
local badgeSize = 22
local pinned = {} -- window id -> { win = hs.window, badge = hs.canvas }

local function yabaiCmd(args)
	local out, ok = hs.execute(yabai .. " -m " .. args .. " 2>&1")
	return ok, out
end

local function badgeFrame(win)
	local f = win:frame()
	return { x = f.x + f.w - badgeSize - 8, y = f.y + 5, w = badgeSize, h = badgeSize }
end

-- Show a badge only while its window is on a visible space and not minimized.
local function refreshBadge(entry)
	local win = entry.win
	local visible = false
	if win:isVisible() then
		local active = hs.spaces.activeSpaces()
		for _, space in ipairs(hs.spaces.windowSpaces(win) or {}) do
			for _, activeSpace in pairs(active) do
				if space == activeSpace then
					visible = true
				end
			end
		end
	end
	if visible then
		entry.badge:frame(badgeFrame(win)):show()
	else
		entry.badge:hide()
	end
end

local unpin

local function makeBadge(id)
	local badge = hs.canvas.new({ x = 0, y = 0, w = badgeSize, h = badgeSize })
	badge:appendElements({
		type = "text",
		text = "📌",
		textSize = 15,
		textAlignment = "center",
		frame = { x = 0, y = 1, w = badgeSize, h = badgeSize },
	})
	badge:level(hs.canvas.windowLevels.floating)
	badge:behavior({ "canJoinAllSpaces", "transient" })
	badge:clickActivating(false)
	badge:canvasMouseEvents(true, false, false, false)
	badge:mouseCallback(function()
		unpin(id)
	end)
	return badge
end

-- quiet: the window is already on the above layer (restoring after a reload).
local function pin(win, quiet)
	local id = win:id()
	if not quiet then
		local ok, out = yabaiCmd(string.format("window %d --sub-layer above", id))
		if not ok then
			hs.alert.show("Always on top failed: " .. (out ~= "" and out or "is yabai running?"), 3)
			return
		end
		hs.alert.show("Always on top: on", 0.3)
	end
	pinned[id] = { win = win, badge = makeBadge(id) }
	refreshBadge(pinned[id])
end

-- windowGone: the window was closed, so there's no layer left to reset.
function unpin(id, windowGone)
	local entry = pinned[id]
	if not entry then
		return
	end
	entry.badge:delete()
	pinned[id] = nil
	if not windowGone then
		yabaiCmd(string.format("window %d --sub-layer auto", id))
		hs.alert.show("Always on top: off", 0.3)
	end
end

hs.hotkey.bind({ "ctrl", "cmd" }, "t", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	if pinned[win:id()] then
		unpin(win:id())
	else
		pin(win)
	end
end)

-- Keep badges glued to their windows.
local watcher = hs.window.filter.new(nil)
watcher:subscribe({
	hs.window.filter.windowMoved,
	hs.window.filter.windowMinimized,
	hs.window.filter.windowUnminimized,
	hs.window.filter.windowHidden,
	hs.window.filter.windowVisible,
	hs.window.filter.windowDestroyed,
}, function(win, _, event)
	local id = win and win:id()
	local entry = id and pinned[id]
	if not entry then
		return
	end
	if event == hs.window.filter.windowDestroyed then
		unpin(id, true)
	else
		refreshBadge(entry)
	end
end)

local spaceWatcher = hs.spaces.watcher.new(function()
	for _, entry in pairs(pinned) do
		refreshBadge(entry)
	end
end)
spaceWatcher:start()

-- yabai keeps the layer across Hammerspoon reloads; pick those windows back up.
do
	local ok, out = yabaiCmd("query --windows")
	local windows = ok and hs.json.decode(out) or {}
	for _, w in ipairs(windows) do
		local win = w["sub-layer"] == "above" and hs.window.get(w.id)
		if win then
			pin(win, true)
		end
	end
end

-- keep the watchers from being garbage-collected
return { watcher = watcher, spaceWatcher = spaceWatcher }
