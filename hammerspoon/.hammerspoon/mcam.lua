-- ctrl+cmd+s drives Mcam (~/Code/mac-utils/mcam), the menu-bar app that shows a screen
-- or one window on the "Mcam" virtual camera.
-- Commands go to the app as mcam:// URLs (popup, stop, screen, sound/…, cursor/…).
--
--   s  open the Mcam window: pick a screen or window (vim keys)
--   = / -  zoom in / out (out past 1× shows the whole window)
--
-- Inside the window: ⏎ shares, s stops, a sends only the shared app's sound to Mmix, c the cursor.

local MODS = { "ctrl", "cmd" }

hs.hotkey.bind(MODS, "s", function()
	hs.task.new("/usr/bin/open", nil, { "mcam://popup" }):start()
end)

local function send(path)
	hs.task.new("/usr/bin/open", nil, { "-g", "mcam://" .. path }):start()
	hs.timer.doAfter(0.3, function()
		local state = hs.json.read(os.getenv("HOME") .. "/Library/Application Support/Mcam/state.json")
		if state then
			hs.alert.closeAll(0)
			hs.alert.show("Mcam zoom: " .. state.zoom, 0.6)
		end
	end)
end

hs.hotkey.bind(MODS, "=", function() send("zoom/in") end)
hs.hotkey.bind(MODS, "-", function() send("zoom/out") end)
