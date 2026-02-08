-- move windows
local step = 40

local function move(dx, dy)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local f = win:frame()
	f.x = f.x + dx
	f.y = f.y + dy
	win:setFrame(f)
end

hs.hotkey.bind(
	{ "alt" },
	"k",
	function()
		move(0, -step)
	end,
	nil,
	function()
		move(0, -step)
	end
)

hs.hotkey.bind(
	{ "alt" },
	"j",
	function()
		move(0, step)
	end,
	nil,
	function()
		move(0, step)
	end
)

hs.hotkey.bind(
	{ "alt" },
	"h",
	function()
		move(-step, 0)
	end,
	nil,
	function()
		move(-step, 0)
	end
)

hs.hotkey.bind(
	{ "alt" },
	"l",
	function()
		move(step, 0)
	end,
	nil,
	function()
		move(step, 0)
	end
)

-- resize windows
local resize_step = 80
local function resize(dw, dh)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	f.w = f.w + dw
	f.h = f.h + dh
	win:setFrame(f)
end

hs.hotkey.bind(
	{ "alt", "shift" },
	"k",
	function()
		resize(0, -resize_step)
	end,
	nil,
	function()
		resize(0, -resize_step)
	end
)
hs.hotkey.bind(
	{ "alt", "shift" },
	"j",
	function()
		resize(0, resize_step)
	end,
	nil,
	function()
		resize(0, resize_step)
	end
)
hs.hotkey.bind(
	{ "alt", "shift" },
	"h",
	function()
		resize(-resize_step, 0)
	end,
	nil,
	function()
		resize(-resize_step, 0)
	end
)
hs.hotkey.bind(
	{ "alt", "shift" },
	"l",
	function()
		resize(resize_step, 0)
	end,
	nil,
	function()
		resize(resize_step, 0)
	end
)
