-- ctrl+cmd+c drives Mclaude (~/Code/mac-utils/mclaude), the menu-bar app that switches every
-- Claude Code terminal to another saved account.
-- Commands go to the app as mclaude:// URLs (popup, next, add, restart-others, switch/<email|n>).
--
--   c        open the Mclaude window (vim keys)
--   shift+c  switch to the next saved account
--
-- Inside the window: ⏎ on an account switches to it, ⏎ on a session restarts it on the account
-- in use (same conversation), 1–9 picks an account, a adds one, R restarts the sessions left on others.

local MODS = { "ctrl", "cmd" }
local SUMMARY = os.getenv("HOME") .. "/Library/Application Support/Mclaude/summary.json"

hs.hotkey.bind(MODS, "c", function()
	hs.task.new("/usr/bin/open", nil, { "mclaude://popup" }):start()
end)

hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "c", function()
	hs.task.new("/usr/bin/open", nil, { "-g", "mclaude://next" }):start()
	hs.timer.doAfter(0.6, function()
		local state = hs.json.read(SUMMARY)
		if state and state.active ~= "" then
			hs.alert.closeAll(0)
			hs.alert.show("Claude: " .. state.active, 1)
		end
	end)
end)
