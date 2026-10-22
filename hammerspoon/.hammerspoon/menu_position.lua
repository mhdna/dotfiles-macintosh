-- Shared placement and sizing so every popup menu (cmd+space app launcher,
-- cmd+shift+space command window, mic/output pickers, ...) appears at the
-- exact same spot and a readable size.
local M = {}

local VERTICAL_OFFSET = 250

-- hs.chooser sizes itself as a percentage of the screen width, which leaves
-- the menus tiny on small screens. Never let a chooser get narrower than this
-- many pixels (it still tops out at 90% of the screen).
local MIN_CHOOSER_WIDTH_PX = 440
local MAX_CHOOSER_WIDTH_PERCENT = 90

function M.point(width, height)
	height = height or 0
	local screen = hs.screen.mainScreen():frame()
	return {
		x = screen.x + (screen.w - width) / 2,
		y = screen.y + (screen.h - height) / 2 - VERTICAL_OFFSET,
	}
end

-- Width for a chooser that wants `percent` of the screen, as {percent, pixels}
-- to hand to chooser:width() and M.point().
function M.chooserWidth(percent)
	local screen = hs.screen.mainScreen():frame()
	local px = math.max(screen.w * percent / 100, MIN_CHOOSER_WIDTH_PX)
	local pct = math.min(px / screen.w * 100, MAX_CHOOSER_WIDTH_PERCENT)
	return pct, screen.w * pct / 100
end

-- Shows `chooser` at the shared spot, `percent` of the screen wide (or the
-- minimum above on a small screen). Sized on every show, since the screen it
-- opens on can change.
function M.showChooser(chooser, percent)
	local pct, px = M.chooserWidth(percent)
	chooser:width(pct)
	chooser:show(M.point(px))
end

return M
