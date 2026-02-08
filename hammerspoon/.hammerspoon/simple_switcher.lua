-- TODO: uses hs.window.filter right now but would it be better to watch window creation / deletion / space-moving / etc with hs.uielement.watcher and keep some internal table up to date with that?
-- TODO: notice when a window gets sent to another space and rebuild the window list

local hsdrawing = require("hs.drawing")
local hseventtap = require("hs.eventtap")
local hsgeom = require("hs.geometry")
local hsimage = require("hs.image")
local hsscreen = require("hs.screen")
local hstimer = require("hs.timer")

local min = math.min
local max = math.max
local checkMods = hseventtap.checkKeyboardModifiers
hs.window.animationDuration = 0
local UNAVAILABLE = hsimage.imageFromName("NSStopProgressTemplate")

local simple_switcher = {}

local icons = setmetatable({}, { __mode = "kv" })
local function getIcon(bundle)
	if not bundle then
		return UNAVAILABLE
	elseif not icons[bundle] then
		icons[bundle] = hsimage.imageFromAppBundle(bundle) or UNAVAILABLE
	end
	return icons[bundle]
end

local function rgba(r, g, b, a)
	return { red = r, green = g, blue = b, alpha = a }
end
local function rgb(r, g, b, a)
	return rgba(r, g, b, 1)
end

local function gc(self)
	self.screen_watcher:stop()
end

local function set_frames(nwindows, drawings, ui)
	if not drawings.screen_frame then
		drawings.screen_frame = hsscreen.mainScreen():frame()
	end
	local screen_frame = drawings.screen_frame
	local padding = ui.item_height * 0.1
	local size = min(ui.item_height, (screen_frame.h - padding * (nwindows + 1)) / nwindows)
	drawings.size = size
	-- TODO: pin to some corner (top-left) + padding, or center?
	-- TODO: expand in x to longest title?
	drawings.background = hsdrawing.rectangle(hsgeom(0, 0, 1, 1))
	local bg_frame =
		hsgeom(0, 0, size + padding + ui.title_width + padding, (size + padding) * nwindows + padding):setcenter(
			screen_frame.center
		)
	drawings.background
		:setFillColor(ui.background_color)
		:setStroke(false)
		:setFrame(bg_frame)
		:setRoundedRectRadii(padding, padding)

	drawings.highlight_rect = hsdrawing
		.rectangle(hsgeom(0, 0, 1, 1))
		:setFillColor(ui.highlight_color)
		:setStroke(false)
		:setRoundedRectRadii(padding, padding)

	local title_height = hsdrawing.getTextDrawingSize("O", ui.title_text_style).h

	for i = 1, nwindows do
		local dr = drawings[i]
		local icon_frame =
			hsgeom(bg_frame.x, bg_frame.y, size, size):move(padding, padding + (size + padding) * (i - 1))
		dr.icon:setFrame(icon_frame)
		dr.title_frame =
			hsgeom.copy(icon_frame):move(padding * 2 + size, max(0, size - title_height) / 2):setw(ui.title_width)
		local sel_frame = hsgeom.copy(icon_frame):setw(size + ui.title_width)
		dr.sel_frame = sel_frame
	end
end

local function show_selected(selected, drawings)
	local dr = drawings[selected]
	drawings.highlight_rect:setFrame(dr.sel_frame)
end

local function draw(windows, drawings, ui)
	drawings.background:show()
	drawings.highlight_rect:show()
	for i = 1, #windows do
		local win = windows[i]
		local dr = drawings[i]
		dr.icon:setImage(getIcon(win:application():bundleID())):show()
		local title = win:title() or " "
		dr.title_text:setFrame(dr.title_frame)
		dr.title_text:setText(title):show()
	end
end

local MODS_INTERVAL = 0.05 -- recheck for (lack of) mod keys after this interval
local function mods_pressed()
	local mods = checkMods(true)._raw
	return mods > 0 and mods ~= 65536 -- caps lock
end

local function exit(self)
	local selected = self.selected
	local windows = self.windows
	local drawings = self.drawings
	local ui = self.ui
	self.windows = nil
	self.selected = nil
	self.modsTimer = nil
	drawings.background:hide()
	drawings.highlight_rect:hide()
	for i = 1, #windows do
		local dr = drawings[i]
		dr.icon:hide()
		dr.title_text:hide()
	end
	windows[selected]:focus()
end

local function show(self, direction)
	local windows = self.windows
	local drawings = self.drawings
	local ui = self.ui

	if not windows then
		windows = self.window_filter:getWindows(hs.window.filter.sortByFocusedLast)
		self.windows = windows
	end
	local nwindows = #windows or 0
	if nwindows == 0 then
		return
	end

	self.ui.title_text_style = {
		font = ui.font_name,
		size = ui.font_size,
		color = ui.text_color,
		lineBreak = "truncateTail",
	}

	local selected = self.selected
	if not selected then
		local temp_frame = hsgeom(0, 0, 1, 1)
		for n = 1, nwindows do
			local dr = {}
			dr.icon = hsdrawing.image(temp_frame, UNAVAILABLE)
			dr.title_rect = hsdrawing.rectangle(temp_frame):setFillColor(ui.title_background_color):setStroke(false)
			dr.title_text = hsdrawing.text(temp_frame, " "):setTextStyle(self.ui.title_text_style)
			drawings[n] = dr
		end
		set_frames(nwindows, drawings, ui)
		draw(windows, drawings, ui)
		selected = 1
		self.modsTimer = hstimer.waitWhile(mods_pressed, function()
			exit(self)
		end, MODS_INTERVAL)
	end

	selected = selected + direction
	if selected <= 0 then
		selected = nwindows
	elseif selected > nwindows then
		selected = 1
	end
	self.selected = selected
	show_selected(selected, drawings)
end

function simple_switcher:next()
	return show(self, 1)
end
function simple_switcher:previous()
	return show(self, -1)
end

local ui_defaults = {
	text_color = rgb(1, 1, 1),
	font_name = "Monaco",
	font_size = 22,

	background_color = rgba(0.2, 0.2, 0.08, 0.8),
	highlight_color = rgba(0.6, 0.6, 0.3, 0.5),

	title_background_color = rgb(0, 0, 0),

	item_height = 64,
	title_width = 600,
	-- TODO: thumbnails
}

function simple_switcher.new(ui)
	if not ui then
		ui = {}
	end
	local self = setmetatable({ drawings = {} }, { __index = simple_switcher, __gc = gc })
	self.window_filter = hs.window.filter.new():setCurrentSpace(true)
	self.drawings.screen_frame = nil
	self.screen_watcher = hs.screen.watcher
		.new(function()
			self.drawings.screen_frame = nil
		end)
		:start()
	self.ui = setmetatable(ui, { __index = ui_defaults })
	return self
end

return simple_switcher
