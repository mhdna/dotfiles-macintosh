-- opt+ctrl+w: redraw the Mlife life-timeline wallpaper now (e.g. after editing its config).
-- Mlife (~/Code/mac-utils/mlife) listens for a distributed notification; starts it if it isn't running.

local BUNDLE = "com.mahdi.mlife"

hs.hotkey.bind({ "ctrl", "alt" }, "w", function()
	if hs.application.get(BUNDLE) then
		hs.distributednotifications.post("com.mahdi.mlife.refresh", nil)
	else
		hs.task.new("/usr/bin/open", nil, { "-g", "-b", BUNDLE }):start()
	end
end)
