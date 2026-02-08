local switcher = hs.window.switcher.new(nil, {
	showTitles = true,
	showThumbnails = false,
	showSelectedThumbnail = false,
	showSelectedTitle = true,
	showAppIcons = false,
	backgroundColor = { 0, 0, 0, 0.8 },
	highlightColor = { 0.3, 0.3, 0.3, 0.8 },
	titleBackgroundColor = { 0, 0, 0, 0 },
	fontSize = 16,
	textColor = { 1, 1, 1 },
	showOutline = false,
})

local function mapAltTab(event)
	local flags = event:getFlags()
	local chars = event:getCharacters()
	if chars == "\t" and flags:containExactly({ "cmd" }) then
		switcher:next()
		return true
	elseif chars == string.char(25) and flags:containExactly({ "cmd", "shift" }) then
		switcher:previous()
		return true
	end
end
tapAltTab = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, mapAltTab)
tapAltTab:start()

tapAltTab = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, mapAltTab)

tapAltTab:start()
