-- xkill-style force kill: ctrl+cmd+x, then click a window to SIGKILL its app
local killTap = nil
local escTap = nil

local function stopKillMode()
	if killTap then
		killTap:stop()
		killTap = nil
	end
	if escTap then
		escTap:stop()
		escTap = nil
	end
end

local function windowAtPoint(pt)
	for _, win in ipairs(hs.window.orderedWindows()) do
		local f = win:frame()
		if pt.x >= f.x and pt.x <= f.x + f.w and pt.y >= f.y and pt.y <= f.y + f.h then
			return win
		end
	end
	return nil
end

local function startKillMode()
	hs.alert.show("Click a window to force kill (esc to cancel)", 3)

	killTap = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function()
		local pt = hs.mouse.absolutePosition()
		local win = windowAtPoint(pt)
		stopKillMode()

		if win then
			local app = win:application()
			if app then
				local name = app:name()
				app:kill9()
				hs.alert.show("Force killed: " .. name, 1)
			end
		end

		return true -- swallow the click so it doesn't reach the app underneath
	end)
	killTap:start()

	escTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
		if event:getKeyCode() == hs.keycodes.map["escape"] then
			stopKillMode()
			hs.alert.show("Cancelled", 0.5)
			return true
		end
		return false
	end)
	escTap:start()
end

hs.hotkey.bind({ "ctrl", "cmd" }, "x", function()
	if killTap then
		stopKillMode()
		hs.alert.show("Cancelled", 0.5)
	else
		startKillMode()
	end
end)
