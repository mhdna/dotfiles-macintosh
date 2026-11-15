-- opt+d: show the desktop with macOS's own Show Desktop (same as F11), and again to bring the
-- windows back. One native call; turn on Reduce motion to swap its slide for a quick fade.

hs.hotkey.bind({ "alt" }, "d", function()
	hs.spaces.toggleShowDesktop()
end)
