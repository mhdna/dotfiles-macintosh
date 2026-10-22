-- opt+shift+s: pick a script from a list and run it (via zsh, aliases/PATH loaded).
-- Add entries to SCRIPTS below.
local menuPosition = require("menu_position")

local SCRIPTS = {
	{ text = "BNC report", subText = "Today's report: image + PDF to drag, text copied", cmd = "cd ~/Code/bnc && make report" },
	{ text = "BNC weekly report", subText = "Last 7 days: image + PDF to drag, text copied", cmd = "cd ~/Code/bnc && make report-weekly" },
}

local function run(choice)
	if not choice then
		return
	end
	hs.alert.show(choice.text .. "…", 1)
	hs.timer.doAfter(0, function() -- let the menu close first
		hs.task
			.new("/bin/zsh", function(exitCode, stdOut, stdErr)
				if exitCode == 0 then
					hs.alert.show(choice.text .. ": ready", 1.5)
				else
					local err = ((stdErr or "") .. (stdOut or "")):gsub("%s+$", "")
					hs.alert.show(choice.text .. " failed:\n" .. err:sub(-300), 6)
				end
			end, { "-i", "-c", choice.cmd })
			:start()
	end)
end

local chooser = hs.chooser.new(run)
chooser:width(30)
chooser:rows(math.max(#SCRIPTS + 1, 4)) -- rows with a subText are taller; leave room so none is cut off
chooser:choices(SCRIPTS)

hs.hotkey.bind({ "alt", "shift" }, "s", function()
	chooser:query("")
	menuPosition.showChooser(chooser, 30)
end)
