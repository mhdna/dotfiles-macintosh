local currentIndex = 0
local lastApp = nil

local function getWindows(app)
	local wins = {}
	for _, w in ipairs(app:allWindows()) do
		if w:isStandard() then
			table.insert(wins, w)
		end
	end
	return wins
end

hs.hotkey.bind({ "alt" }, "\\", function()
	local app = hs.application.frontmostApplication()
	if not app then
		return
	end

	local wins = getWindows(app)
	if #wins < 2 then
		return
	end

	-- reset when switching apps
	if lastApp ~= app then
		currentIndex = 1
		lastApp = app
	else
		currentIndex = (currentIndex % #wins) + 1
	end

	wins[currentIndex]:focus()
end)

hs.hotkey.bind({ "alt", "shift" }, "\\", function()
	local app = hs.application.frontmostApplication()
	if not app then
		return
	end

	local wins = getWindows(app)
	if #wins < 2 then
		return
	end

	if lastApp ~= app then
		currentIndex = #wins
		lastApp = app
	else
		currentIndex = (currentIndex - 2) % #wins + 1
	end

	wins[currentIndex]:focus()
end)
