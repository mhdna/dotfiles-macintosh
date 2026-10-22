-- Sends Finder windows to lf-gui instead.
-- macOS won't let another app replace Finder for "Show in Finder" / a
-- browser's "Show in folder" (those call Finder directly), so this watches
-- for new Finder windows, reads the folder (and selected file) they show,
-- closes them and opens the same spot in lf-gui. Mounted disk images stay.
-- ctrl+opt+f turns the redirect off and on, for when you want real Finder.
-- Needs permission for Hammerspoon to control Finder (macOS asks once).
local lfGui = "com.mahdi.lf-gui"
local enabled = true

-- Returns the selected item if it's inside the window's folder, else the
-- folder itself. Special windows (Recents, AirDrop, Trash) have no folder
-- and are left alone.
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
	return outPath
end tell
]]

-- A mounted .dmg's window stays in Finder: dragging its app to Applications
-- only works there (and redirecting it made Finder reopen it, over and over).
local function onDiskImage(path)
	local root = path:match("^(/Volumes/[^/]+)")
	if not root then
		return false
	end
	local mounts = hs.execute("/usr/bin/hdiutil info")
	return mounts ~= nil and mounts:find("\t" .. root .. "\n", 1, true) ~= nil
end

local function redirect()
	if not enabled then
		return
	end
	local ok, path = hs.osascript.applescript(script)
	if not (ok and path and path ~= "") or onDiskImage(path) then
		return
	end
	hs.osascript.applescript('tell application "Finder" to close front Finder window')
	hs.task.new("/usr/bin/open", nil, { "-b", lfGui, path }):start()
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
