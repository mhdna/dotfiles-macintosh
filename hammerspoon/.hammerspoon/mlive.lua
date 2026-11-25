-- ctrl+cmd+e drives Mlive (~/Code/mac-utils/mlive), the menu-bar app that captions and
-- translates non-English speech live. Commands go to the app as mlive:// URLs; it reports
-- back through ~/Library/Application Support/Mlive/state.json, read for the alert.
--
--   e        open the Mlive window: what to listen to, translate into, leave alone (vim keys)
--   shift+e  start / stop listening

local MODS = { "ctrl", "cmd" }
local tr = require("i18n").t
local STATE = os.getenv("HOME") .. "/Library/Application Support/Mlive/state.json"

hs.hotkey.bind(MODS, "e", function()
	hs.task.new("/usr/bin/open", nil, { "mlive://popup" }):start()
end)

hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "e", function()
	hs.task.new("/usr/bin/open", nil, { "-g", "mlive://toggle" }):start()
	hs.timer.doAfter(0.4, function()
		local s = hs.json.read(STATE)
		if not s then return end
		hs.alert.closeAll(0)
		local text = s.listening and (tr("Mlive listening: ") .. s.source .. " → " .. s.target) or tr("Mlive stopped")
		if s.status and s.status ~= "" then text = text .. "\n" .. s.status end
		hs.alert.show(text, 1)
	end)
end)
