-- Shared placement so every popup menu (cmd+space app launcher, cmd+shift+space
-- command window, mic/output pickers, ...) appears at the exact same spot.
local M = {}

local VERTICAL_OFFSET = 250

function M.point(width, height)
	height = height or 0
	local screen = hs.screen.mainScreen():frame()
	return {
		x = screen.x + (screen.w - width) / 2,
		y = screen.y + (screen.h - height) / 2 - VERTICAL_OFFSET,
	}
end

return M
