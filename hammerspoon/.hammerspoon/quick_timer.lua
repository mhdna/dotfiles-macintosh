-- ctrl+cmd+t: quick countdown timer. Type a time, hit return, it counts down in the menu bar.
--
--   5          5 minutes
--   90s        90 seconds
--   1h30       1 hour 30 minutes (also 1h 30m, 1h30m)
--   2:30       2 minutes 30 seconds (h:mm:ss works too)
--   25m tea    anything after the time is the timer's name
--
-- Several timers can run at once; the menu bar shows the one ending soonest, and its menu (or
-- ctrl+cmd+t again) lists them all so you can cancel one. When a timer ends it rings until you
-- press esc or ctrl+cmd+t (or after 30 seconds).

local M = {}

local SOUND = "Glass"
local RING_FOR = 30 -- seconds
local tr = require("i18n").t -- "tr", not "t": ring(t) and others use t for a timer
local RECENT_KEY = "quick_timer.recent"
local DEFAULTS = { "5m", "10m", "15m", "25m" } -- always offered, after the recent ones

local timers = {} -- { id, label, ends }
local nextId = 1
local menubar, ticker
local ringing -- { sound, alerts, repeater, stopper, escKey }

local function fmt(secs)
	secs = math.max(0, math.floor(secs + 0.5))
	local h, m, s = secs // 3600, secs % 3600 // 60, secs % 60
	if h > 0 then
		return string.format("%d:%02d:%02d", h, m, s)
	end
	return string.format("%d:%02d", m, s)
end

-- Plain words for a duration, e.g. "1h 30m", "90s" -> "1m 30s".
local function words(secs)
	local h, m, s = secs // 3600, secs % 3600 // 60, secs % 60
	local parts = {}
	if h > 0 then table.insert(parts, h .. "h") end
	if m > 0 then table.insert(parts, m .. "m") end
	if s > 0 then table.insert(parts, s .. "s") end
	return table.concat(parts, " ")
end

local MULT = { h = 3600, m = 60, s = 1 }
local UNITS = {}
for unit, names in pairs({
	h = { "h", "hr", "hrs", "hour", "hours" },
	m = { "m", "min", "mins", "minute", "minutes" },
	s = { "s", "sec", "secs", "second", "seconds" },
}) do
	for _, n in ipairs(names) do UNITS[n] = unit end
end

-- "25m tea" -> 1500, "tea". Returns nil when the text doesn't start with a time.
local function parse(text)
	text = (text or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if text == "" then return nil end

	-- h:mm:ss or m:ss
	local a, b, c, rest = text:match("^(%d+):(%d%d):(%d%d)%s*(.*)$")
	if a then
		return tonumber(a) * 3600 + tonumber(b) * 60 + tonumber(c), rest
	end
	a, b, rest = text:match("^(%d+):(%d%d)%s*(.*)$")
	if a then
		return tonumber(a) * 60 + tonumber(b), rest
	end

	-- units: 1h30m, 1h 30, 90s, 2.5m, 10 min; a plain number is minutes
	local total, pos, last = 0, 1, nil
	while true do
		local num, numEnd, word, wordEnd = text:match("^%s*(%d+%.?%d*)()%s*(%a*)()", pos)
		if not num then break end
		local unit = UNITS[word:lower()]
		local after = wordEnd
		if not unit then
			-- no unit (or the name starts right away): a bare number after hours means
			-- minutes, after minutes seconds, and on its own minutes
			unit = (last == nil and "m") or (last == "h" and "m") or (last == "m" and "s") or nil
			if not unit then break end
			after = numEnd
		end
		total = total + tonumber(num) * MULT[unit]
		last, pos = unit, after
		if after == numEnd then break end
	end
	if total <= 0 then return nil end
	return math.floor(total + 0.5), (text:sub(pos):gsub("^%s+", ""))
end

local function recent()
	local list = hs.settings.get(RECENT_KEY)
	if type(list) ~= "table" then return {} end
	return list
end

-- recent times first, then any default not already among them
local function presets()
	local out, seen = {}, {}
	for _, list in ipairs({ recent(), DEFAULTS }) do
		for _, t in ipairs(list) do
			local s, l = parse(t)
			local key = tostring(s) .. "|" .. tostring(l)
			if s and not seen[key] then
				seen[key] = true
				table.insert(out, t)
			end
		end
	end
	return out
end

local function remember(text)
	local list = { text }
	for _, t in ipairs(recent()) do
		if t ~= text and #list < 6 then table.insert(list, t) end
	end
	hs.settings.set(RECENT_KEY, list)
end

local function stopRinging()
	if not ringing then return end
	if ringing.sound then ringing.sound:stop() end
	for _, uuid in ipairs(ringing.alerts) do hs.alert.closeSpecific(uuid, 0.2) end
	ringing.repeater:stop()
	ringing.stopper:stop()
	ringing.escKey:delete()
	ringing = nil
end

local function ring(t)
	stopRinging()
	local text = t.label ~= "" and tr("Time's up: %s", t.label) or tr("Time's up")
	local style = { textSize = 44, padding = 36, radius = 18 }
	local alerts = {}
	for _, screen in ipairs(hs.screen.allScreens()) do
		table.insert(alerts, hs.alert.show(text, style, screen, RING_FOR))
	end
	local sound = hs.sound.getByName(SOUND)
	if sound then sound:play() end
	ringing = {
		sound = sound,
		alerts = alerts,
		repeater = hs.timer.doEvery(2, function()
			if sound and not sound:isPlaying() then sound:play() end
		end),
		stopper = hs.timer.doAfter(RING_FOR, stopRinging),
		escKey = hs.hotkey.bind({}, "escape", stopRinging),
	}
	hs.notify.new({ title = text, subTitle = tr("%s timer", words(t.duration)), withdrawAfter = 0 }):send()
end

local function sorted()
	table.sort(timers, function(x, y) return x.ends < y.ends end)
	return timers
end

local function remove(id)
	for i, t in ipairs(timers) do
		if t.id == id then
			table.remove(timers, i)
			return t
		end
	end
end

local function refresh()
	local now = hs.timer.secondsSinceEpoch()
	local done = {}
	for _, t in ipairs(sorted()) do
		if t.ends <= now then table.insert(done, t) end
	end
	for _, t in ipairs(done) do
		remove(t.id)
		ring(t)
	end
	if #timers == 0 then
		if ticker then ticker:stop(); ticker = nil end
		if menubar then menubar:delete(); menubar = nil end
		return
	end
	if not menubar then menubar = hs.menubar.new() end
	local first = timers[1]
	local title = "⏱ " .. fmt(first.ends - now)
	if #timers > 1 then title = title .. "  +" .. (#timers - 1) end
	menubar:setTitle(title)
	menubar:setMenu(function()
		local items = {}
		local n = hs.timer.secondsSinceEpoch()
		for _, t in ipairs(sorted()) do
			local name = t.label ~= "" and t.label or words(t.duration)
			table.insert(items, { title = string.format(tr("Cancel %s (%s left)"), name, fmt(t.ends - n)), fn = function()
				remove(t.id)
				refresh()
			end })
		end
		table.insert(items, { title = "-" })
		table.insert(items, { title = tr("New timer"), fn = function() M.open() end })
		return items
	end)
end

local function start(secs, label)
	table.insert(timers, {
		id = nextId,
		label = label or "",
		duration = secs,
		ends = hs.timer.secondsSinceEpoch() + secs,
	})
	nextId = nextId + 1
	if not ticker then ticker = hs.timer.doEvery(1, refresh) end
	refresh()
	local name = (label and label ~= "") and (label .. ", ") or ""
	hs.alert.show(tr("Timer: ") .. name .. words(secs), 1)
end

local chooser

local function rows(query)
	local out = {}
	local secs, label = parse(query)
	if secs then
		local name = label ~= "" and (label .. ", ") or ""
		table.insert(out, {
			text = tr("Start ") .. name .. words(secs),
			subText = tr("ends at ") .. os.date("%H:%M", os.time() + secs),
			action = "start", secs = secs, label = label, query = query,
		})
	end
	if query == "" then
		local now = hs.timer.secondsSinceEpoch()
		for _, t in ipairs(sorted()) do
			local name = t.label ~= "" and t.label or words(t.duration)
			table.insert(out, {
				text = tr("Cancel ") .. name,
				subText = fmt(t.ends - now) .. tr(" left"),
				action = "cancel", id = t.id,
			})
		end
		for _, r in ipairs(presets()) do
			local s, l = parse(r)
			if s then
				local name = l ~= "" and (l .. ", ") or ""
				table.insert(out, {
					text = tr("Start ") .. name .. words(s),
					subText = tr("preset"),
					action = "start", secs = s, label = l, query = r,
				})
			end
		end
	end
	if #out == 0 then
		table.insert(out, { text = tr("Type a time: 5, 90s, 1h30, 2:30, 25m tea"), action = "none" })
	end
	return out
end

function M.open()
	if ringing then
		stopRinging()
		return
	end
	if not chooser then
		chooser = hs.chooser.new(function(choice)
			if not choice then return end
			if choice.action == "start" then
				remember(choice.query)
				start(choice.secs, choice.label)
			elseif choice.action == "cancel" then
				remove(choice.id)
				refresh()
			end
		end)
		chooser:placeholderText(tr("Timer: 5, 90s, 1h30, 2:30, 25m tea"))
		chooser:rows(8)
		chooser:queryChangedCallback(function(q) chooser:choices(rows(q)) end)
	end
	chooser:query("")
	chooser:choices(rows(""))
	chooser:show()
end

M.parse = parse

hs.hotkey.bind({ "ctrl", "cmd" }, "t", M.open)

return M
