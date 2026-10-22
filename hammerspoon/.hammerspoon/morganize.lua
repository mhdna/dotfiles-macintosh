-- ctrl+cmd+o opens Morganize (~/Code/mac-utils/morganize), which lets apps run only in the
-- times set for their group. Commands go to the app as morganize:// URLs (show, unlock/<bundle id>).

hs.hotkey.bind({ "ctrl", "cmd" }, "o", function()
	hs.task.new("/usr/bin/open", nil, { "morganize://show" }):start()
end)
