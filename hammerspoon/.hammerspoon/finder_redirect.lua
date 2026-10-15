-- Sends Finder windows to lf-gui instead.
-- macOS won't let another app replace Finder for "Show in Finder" / a
-- browser's "Show in folder" (those call Finder directly), so this watches
-- for new Finder windows, reads the folder (and selected file) they show,
-- closes them and opens the same spot in lf-gui.
-- ctrl+opt+f turns the redirect off and on, for when you want real Finder.
-- Needs permission for Hammerspoon to control Finder (macOS asks once).
local lfGui = "com.mahdi.lf-gui"
local enabled = true

-- Returns the selected item if it's inside the window's folder, else the
-- folder itself, and closes the window. Special windows (Recents, AirDrop,
-- Trash) have no folder and are left alone.
local script = [[
tell application "Finder"
	if (count of Finder windows) = 0 then return ""
	set w to front Finder window
	try
		set folderPath to POSIX path of (target of w as alias)
	on error
		return ""
	end try
	set outPath to folderPath
	try
		set sel to selection
		if (count of sel) > 0 then
			set itemPath to POSIX path of (item 1 of sel as alias)
			if itemPath starts with folderPath then set outPath to itemPath
		end if
	end try
	close w
	return outPath
end tell
]]

local function redirect()
	if not enabled then
		return
	end
	local ok, path = hs.osascript.applescript(script)
	if ok and path and path ~= "" then
		hs.task.new("/usr/bin/open", nil, { "-b", lfGui, path }):start()
	end
end

local watcher = hs.window.filter.new("Finder")
watcher:subscribe(hs.window.filter.windowCreated, function()
	-- Give Finder a moment to point the new window at its folder.
	hs.timer.doAfter(0.15, redirect)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "f", function()
	enabled = not enabled
	hs.alert.show(enabled and "Finder → lf-gui: on" or "Finder → lf-gui: off (Finder works normally)", 1)
end)

-- keep the watcher from being garbage-collected
return { watcher = watcher }
