-- toggle always-on-top for the focused window
-- hs.window has no window-level API, so we emulate it by re-raising
-- pinned windows whenever focus changes elsewhere.
-- NOTE: this cannot put a background window above the currently active
-- app's windows (macOS always stacks the active app on top) -- it only
-- keeps pinned windows raised above other background windows.
local pinnedWindows = {}

local function raisePinned()
	for _, win in pairs(pinnedWindows) do
		win:raise()
	end
end

local watcher = hs.window.filter.new()
watcher:subscribe({ hs.window.filter.windowFocused, hs.window.filter.windowCreated }, raisePinned)

hs.hotkey.bind({ "ctrl", "cmd" }, "t", function()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local id = win:id()
	if pinnedWindows[id] then
		pinnedWindows[id] = nil
		hs.alert.show("Always on top: off", 0.3)
	else
		pinnedWindows[id] = win
		win:raise()
		hs.alert.show("Always on top: on", 0.3)
	end
end)
