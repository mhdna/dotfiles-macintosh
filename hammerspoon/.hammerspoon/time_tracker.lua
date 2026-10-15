-- ctrl+alt+S/T/P/D/J: Obsidian Menu-Bar Time Tracker commands, from any app
-- (the plugin's own hotkeys only fire while Obsidian is focused)

local commands = {
	S = "toggle-timer", -- start / stop
	T = "start-timer-on", -- pick a card / switch
	P = "pause-timer", -- pause / resume
	D = "finish-card", -- stop & mark done
	J = "open-tracked-board", -- open the card's board
}

for key, cmd in pairs(commands) do
	hs.hotkey.bind({ "ctrl", "alt" }, key, function()
		hs.urlevent.openURL("obsidian://time-tracker?cmd=" .. cmd)
	end)
end
