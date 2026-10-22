-- ctrl+space: a bare input box (no list underneath), in the
-- same dark native chooser the app launcher uses. Type a command, hit enter ->
-- runs via zsh (aliases loaded) and shows the output as a brief alert.
-- Escape or losing focus dismisses it without running anything.
--
-- This used to be a custom web view, which was slow to appear; hs.chooser is
-- native and opens as fast as the cmd+space launcher.
local menuPosition = require("menu_position")

local ALERT_DURATION = 4
local escWatcher = nil

local function dismissOutputEarly()
	if escWatcher then
		escWatcher:stop()
		escWatcher = nil
	end
	hs.alert.closeAll(0)
end

local function showOutput(text)
	hs.alert.show(text, { textFont = "Menlo", radius = 8 }, hs.screen.mainScreen(), ALERT_DURATION)

	escWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
		if event:getKeyCode() == hs.keycodes.map["escape"] then
			dismissOutputEarly()
			return true
		end
		return false
	end)
	escWatcher:start()

	hs.timer.doAfter(ALERT_DURATION, function()
		if escWatcher then
			escWatcher:stop()
			escWatcher = nil
		end
	end)
end

local CHOOSER_WIDTH_PERCENT = 34

local function run(choice)
	-- escape / click-away gives no choice; with no matches and enableDefaultForQuery
	-- the typed text comes back as choice.text
	local cmd = choice and choice.text and choice.text:gsub("^%s+", ""):gsub("%s+$", "")
	if not cmd or cmd == "" then
		return
	end
	hs.timer.doAfter(0, function() -- let the box close first
		hs.task
			.new("/bin/zsh", function(exitCode, stdOut, stdErr)
				local output = (stdOut or "") .. (stdErr or "")
				output = output:gsub("%s+$", "")
				if output == "" then
					output = "(no output, exit " .. exitCode .. ")"
				end
				showOutput(output)
			end, { "-i", "-c", cmd })
			:start()
	end)
end

local chooser = hs.chooser.new(run)
chooser:choices({})
chooser:enableDefaultForQuery(true)
chooser:rows(0)
chooser:bgDark(true)
chooser:placeholderText("Run command...")

local function showQuickShell()
	chooser:query("")
	menuPosition.showChooser(chooser, CHOOSER_WIDTH_PERCENT)
end

hs.hotkey.bind({ "ctrl" }, "space", showQuickShell)
