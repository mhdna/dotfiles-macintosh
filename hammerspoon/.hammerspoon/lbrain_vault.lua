-- lbrain_vault.lua: where a captured item goes in the Obsidian vault, and what its Anki card looks
-- like. Pure Lua (no hs.*), so tests/lbrain_vault_test.lua runs it with plain `lua`.

local M = {}

M.DECKS = {
	en_word = "LBrain::English Words",
	en_phrase = "LBrain::English Phrases",
	ar_word = "LBrain::Arabic Words",
	ar_phrase = "LBrain::Arabic Phrases",
	info = "LBrain::Info",
}

M.FILES = {
	en_word = "LBrain/English words.md",
	en_phrase = "LBrain/English phrases.md",
	ar_word = "LBrain/Arabic words.md",
	ar_phrase = "LBrain/Arabic phrases.md",
	info = "LBrain/Info.md",
}

M.LABELS = {
	en_word = "EN word",
	en_phrase = "EN phrase",
	ar_word = "AR word",
	ar_phrase = "AR phrase",
	info = "Info",
}

-- Sections of words and phrases: each is an Anki subdeck of the kind's deck and its own vault file.
-- "Use more" is a no-back card (just the text); the others have a back. cmd+0 in the capture window toggles no-back.
M.CATEGORIES = {
	{ id = "use_more", label = "Use more", single = true },
	{ id = "funny", label = "Funny" },
	{ id = "slang", label = "Slang" },
	{ id = "idiom", label = "Idioms & proverbs" },
}

local function categoryOf(item)
	for _, c in ipairs(M.CATEGORIES) do
		if c.id == item.category then return c end
	end
end

-- The deck an item goes to: the kind's deck, then its category's subdeck.
function M.deckFor(item)
	local deck = M.DECKS[item.kind]
	local cat = deck and item.kind ~= "info" and categoryOf(item)
	if cat then return deck .. "::" .. cat.label end
	return deck
end

-- The vault file: "LBrain/English words.md" -> "LBrain/English words - Funny.md" for a category.
function M.fileFor(item)
	local file = M.FILES[item.kind]
	local cat = file and item.kind ~= "info" and categoryOf(item)
	if cat then return (file:gsub("%.md$", " - " .. cat.label .. ".md")) end
	return file
end

local TEMPLATE = "Sources/Templates/Diary day note.md"

local function read(path)
	local f = io.open(path, "rb")
	if not f then return nil end
	local s = f:read("a")
	f:close()
	return s
end

local function write(path, text)
	local dir = path:match("^(.*)/[^/]+$")
	if dir then os.execute(string.format("mkdir -p %q", dir)) end
	local f, err = io.open(path, "wb")
	if not f then return nil, err end
	f:write(text)
	f:close()
	return true
end

M.read, M.write = read, write

-- kinds that are a word or phrase in English or Arabic
function M.isLanguage(kind) return kind == "en_word" or kind == "en_phrase" or kind == "ar_word" or kind == "ar_phrase" end

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

function M.dayPath(root, date) return root .. "/Journal/Days/" .. date .. ".md" end
function M.newsPath(root) return root .. "/Journal/Events And News.md" end

-- Insert `line` at the end of the section under `heading` (compared trimmed, so "## 2026-10-07 " matches),
-- before the next heading of the same or a higher level; add the heading at the end when it's missing.
function M.insertUnder(text, heading, line)
	local level = #heading:match("^#+")
	local lines = {}
	for l in (text .. "\n"):gmatch("(.-)\n") do lines[#lines + 1] = l end
	if lines[#lines] == "" then lines[#lines] = nil end
	local start
	for i, l in ipairs(lines) do
		if trim(l) == heading then start = i end -- the last one wins, in case of repeats
	end
	if not start then
		if #lines > 0 and trim(lines[#lines]) ~= "" then lines[#lines + 1] = "" end
		lines[#lines + 1] = heading
		lines[#lines + 1] = line
		return table.concat(lines, "\n") .. "\n"
	end
	local stop = #lines + 1
	for i = start + 1, #lines do
		local marks = lines[i]:match("^(#+) ")
		if marks and #marks <= level then
			stop = i
			break
		end
	end
	local at = stop
	while at - 1 > start and trim(lines[at - 1]) == "" do at = at - 1 end
	table.insert(lines, at, line)
	return table.concat(lines, "\n") .. "\n"
end

-- Today's note from the template, if there isn't one yet. Returns its path.
function M.ensureDay(root, date, time)
	local path = M.dayPath(root, date)
	if read(path) then return path end
	local tpl = read(root .. "/" .. TEMPLATE) or ("# " .. date .. " - " .. time .. "\n## Journal\n")
	tpl = tpl:gsub("{{date:YYYY%-MM%-DD}}", date):gsub("{{date}}", date):gsub("{{time}}", time)
	local ok, err = write(path, tpl)
	if not ok then return nil, err end
	return path
end

local function oneLine(s) return (trim(s):gsub("\r?\n", " ")) end

function M.appendJournal(root, date, time, text)
	local path, err = M.ensureDay(root, date, time)
	if not path then return nil, err end
	local body = trim(text):gsub("\n", "\n  ")
	return write(path, M.insertUnder(read(path), "## Journal", "- " .. body))
end

function M.appendNews(root, date, text)
	local path = M.newsPath(root)
	local body = trim(text):gsub("\n", "\n  ")
	return write(path, M.insertUnder(read(path) or "# Events & News\n", "## " .. date, "- " .. body))
end

-- "- **front** — back _(topic, date)_", with the example and a kept recording after it.
function M.cardLine(item, date, audioName, imageName)
	if item.single then
		-- just the text (maybe a list): keep its lines, indented under one bullet
		local body = trim(item.text):gsub("\r?\n", "\n  ")
		local meta = {}
		local topic = oneLine(item.topic or "")
		if topic ~= "" then meta[#meta + 1] = topic end
		meta[#meta + 1] = date
		local line = "- " .. body .. " _(" .. table.concat(meta, ", ") .. ")_"
		if audioName then line = line .. " ![[" .. audioName .. "]]" end
		return line
	end
	local front = oneLine(item.text)
	local line = "- **" .. front .. "**"
	local back = oneLine(item.back or "")
	if back ~= "" then line = line .. " — " .. back end
	local ex = oneLine(item.example or "")
	if ex ~= "" then line = line .. " (e.g. " .. ex .. ")" end
	local meta = {}
	local topic = oneLine(item.topic or "")
	if topic ~= "" then meta[#meta + 1] = topic end
	meta[#meta + 1] = date
	line = line .. " _(" .. table.concat(meta, ", ") .. ")_"
	if audioName then line = line .. " ![[" .. audioName .. "]]" end
	if imageName then line = line .. " ![[" .. imageName .. "|96]]" end
	return line
end

-- Anki's Back field as the capture window builds it ("meaning<br><br><i>example</i><br><br>topic") -> its parts.
function M.parseBack(html)
	local function plain(x) return (tostring(x):gsub("<br%s*/?>", "\n"):gsub("<[^>]*>", ""):gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&amp;", "&"):gsub("^%s+", ""):gsub("%s+$", "")) end
	local keep = {}
	html = tostring(html):gsub("%[sound:[^%]]*%]", function(tag) keep[#keep + 1] = tag return "" end):gsub("<br>%s*$", "")
	local parts, rest = {}, html .. "<br><br>"
	for chunk in rest:gmatch("(.-)<br><br>") do parts[#parts + 1] = chunk end
	local back, example, topic = parts[1] or "", "", ""
	local i = 2
	if parts[i] and parts[i]:match("^<i>.*</i>$") then example = parts[i]; i = i + 1 end
	if parts[i] and not parts[i]:find("%[sound:") and not parts[i]:find("<img") then topic = parts[i] end
	return { front = "", back = plain(back), example = plain(example), topic = plain(topic), keep = table.concat(keep, "<br>") }
end

-- Rewrite the card line "- **front** ..." in its file, keeping the date it was added on.
function M.replaceCard(root, item, date)
	local file = M.fileFor(item)
	if not file then return nil end
	local path = root .. "/" .. file
	local text = read(path)
	if not text then return nil end
	local want = "- **" .. oneLine(item.text):lower() .. "**"
	local out, hit = {}, false
	for raw in (text .. "\n"):gmatch("(.-)\n") do
		local line = raw
		if not hit and line:lower():sub(1, #want) == want then
			hit = true
			line = M.cardLine(item, line:match("(%d%d%d%d%-%d%d%-%d%d)%)_") or date)
		end
		out[#out + 1] = line
	end
	if not hit then return nil end
	if out[#out] == "" then out[#out] = nil end
	return write(path, table.concat(out, "\n") .. "\n")
end

function M.appendCard(root, item, date, audioName, imageName)
	local file = M.fileFor(item)
	if not file then return nil, "no file for " .. tostring(item.kind) end
	local path = root .. "/" .. file
	local text = read(path) or ""
	if text ~= "" and text:sub(-1) ~= "\n" then text = text .. "\n" end
	return write(path, text .. M.cardLine(item, date, audioName, imageName) .. "\n")
end

-- A voice note aimed at "inbox", or an item with no home of its own, lands in LBrain/Inbox.md.
function M.appendInbox(root, item, date, time, audioName)
	local path = root .. "/LBrain/Inbox.md"
	local text = read(path) or ""
	if text ~= "" and text:sub(-1) ~= "\n" then text = text .. "\n" end
	local line = "- " .. date .. " " .. time .. " — " .. trim(item.text):gsub("\n", "\n  ")
	if audioName then line = line .. " ![[" .. audioName .. "]]" end
	return write(path, text .. line .. "\n")
end

local function html(s)
	s = tostring(s or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	return (s:gsub("\r?\n", "<br>"))
end

-- The AnkiConnect "note" for an item. The back is the meaning, an example, the topic, and a
-- [sound:] tag for a kept recording (the file stored with storeMediaFile under audioName).
function M.ankiNote(item, audioName, imageName, pronName)
	local deck = M.deckFor(item)
	if not deck then return nil end
	local extraTags = categoryOf(item) and item.kind ~= "info" and { item.category } or {}
	if item.single then
		local text = html(item.text)
		if (item.topic or "") ~= "" then text = text .. "<br><br><i>" .. html(item.topic) .. "</i>" end
		if audioName then text = text .. "<br>[sound:" .. audioName .. "]" end
		return {
			deckName = deck,
			modelName = M.SINGLE_MODEL.modelName,
			fields = { Text = text },
			options = { allowDuplicate = false, duplicateScope = "deck" },
			tags = { "lbrain", item.kind, "single", table.unpack(extraTags) },
		}
	end
	local back = html(item.back)
	if (item.example or "") ~= "" then back = back .. "<br><br><i>" .. html(item.example) .. "</i>" end
	if (item.topic or "") ~= "" then back = back .. "<br><br>" .. html(item.topic) end
	if audioName then back = back .. "<br>[sound:" .. audioName .. "]" end
	if pronName then back = back .. "<br>[sound:" .. pronName .. "]" end
	if imageName then back = back .. '<br><br><img src="' .. imageName .. '" style="max-height:160px;border-radius:8px">' end
	return {
		deckName = deck,
		modelName = "Basic",
		fields = { Front = html(item.text), Back = back },
		options = { allowDuplicate = false, duplicateScope = "deck" },
		tags = { "lbrain", item.kind, table.unpack(extraTags) },
	}
end

-- Where an item with this kind/target goes: "card", "news", "journal", "todo" or "inbox".
-- A note type with one field: the card shows the text, and "show answer" shows it again, so a list
-- or a fact is just read through and rated. Made in Anki (createModel) when it's missing.
M.SINGLE_MODEL = {
	modelName = "LBrain Note",
	inOrderFields = { "Text" },
	css = ".card { font-family: -apple-system, Arial; font-size: 22px; text-align: left; color: #222; background: #fff; } .nightMode.card, .night_mode .card { color: #eee; background: #2b2c2e; }",
	isCloze = false,
	cardTemplates = { { Name = "Card 1", Front = "{{Text}}", Back = "{{FrontSide}}" } },
}

function M.destination(item)
	if M.DECKS[item.kind] then return "card" end
	if item.kind == "news" or item.kind == "journal" or item.kind == "todo" then return item.kind end
	if item.kind == "voice" then
		if item.target == "news" or item.target == "journal" then return item.target end
		return "inbox"
	end
	return "inbox"
end

-- ---------------------------------------------------------------- todos

-- Todos go to the drag-calendar plugin's task inbox, in the Tasks plugin's format, so both show them.
M.TODO_FILE = "Calendar/Inbox.md"

function M.todoLine(item)
	local line = "- [ ] " .. oneLine(item.text)
	local due = item.due and item.due ~= "" and item.due
	if due then line = line .. " 📅 " .. due end
	-- the Reminder plugin's format, so Obsidian itself reminds too; the block id lets a done mark find the line again
	if due and item.remind then line = line .. " (@" .. due .. (item.time and item.time ~= "" and (" " .. item.time) or "") .. ")" end
	if item.id and item.id ~= "" then line = line .. " ^lb-" .. item.id end
	return line
end

function M.appendTodo(root, item)
	local path = root .. "/" .. M.TODO_FILE
	local text = read(path) or ""
	if text ~= "" and text:sub(-1) ~= "\n" then text = text .. "\n" end
	return write(path, text .. M.todoLine(item) .. "\n")
end

-- ---------------------------------------------------------------- calendar

-- Days since 1970-01-01 for a civil date, and back (Howard Hinnant's algorithms), so date maths
-- never depends on the time zone.
local function dayNum(y, m, d)
	if m <= 2 then y = y - 1 end
	local era = (y >= 0 and y or y - 399) // 400
	local yoe = y - era * 400
	local doy = (153 * (m + (m > 2 and -3 or 9)) + 2) // 5 + d - 1
	local doe = yoe * 365 + yoe // 4 - yoe // 100 + doy
	return era * 146097 + doe - 719468
end

local function fromDayNum(z)
	z = z + 719468
	local era = (z >= 0 and z or z - 146096) // 146097
	local doe = z - era * 146097
	local yoe = (doe - doe // 1460 + doe // 36524 - doe // 146096) // 365
	local y = yoe + era * 400
	local doy = doe - (365 * yoe + yoe // 4 - yoe // 100)
	local mp = (5 * doy + 2) // 153
	local d = doy - (153 * mp + 2) // 5 + 1
	local m = mp + (mp < 10 and 3 or -9)
	if m <= 2 then y = y + 1 end
	return y, m, d
end

local function parseDate(s)
	local y, m, d = tostring(s):match("^(%d%d%d%d)-(%d%d)-(%d%d)")
	if not y then return nil end
	return tonumber(y), tonumber(m), tonumber(d)
end

local function fmtDate(z) return string.format("%04d-%02d-%02d", fromDayNum(z)) end
M.dayNum, M.fromDayNum, M.fmtDate, M.parseDate = dayNum, fromDayNum, fmtDate, parseDate

local function weekday(z) return (z + 4) % 7 end -- 0 = Sunday (1970-01-01 was a Thursday)
local BYDAY = { SU = 0, MO = 1, TU = 2, WE = 3, TH = 4, FR = 5, SA = 6 }

local function contains(list, v)
	for _, x in ipairs(list or {}) do
		if x == v then return true end
	end
	return false
end

-- Does the event start or recur on this day (a day number)?
local function occursOn(ev, z)
	local sy, sm, sd = parseDate(ev.start)
	if not sy then return false end
	local sz = dayNum(sy, sm, sd)
	if z < sz then return false end
	local r = ev.rrule
	if type(r) ~= "table" or not r.freq then return z == sz end
	local interval = math.max(1, tonumber(r.interval) or 1)
	if r["until"] then
		local uy, um, ud = parseDate(r["until"])
		if uy and z > dayNum(uy, um, ud) then return false end
	end
	local freq = tostring(r.freq):lower()
	local y, m, d = fromDayNum(z)
	if freq == "daily" then return (z - sz) % interval == 0 end
	if freq == "weekly" then
		local days = {}
		if type(r.byday) == "table" and #r.byday > 0 then
			for _, code in ipairs(r.byday) do days[BYDAY[tostring(code):upper():sub(-2)] or -1] = true end
		else
			days[weekday(sz)] = true
		end
		if not days[weekday(z)] then return false end
		return (((z - weekday(z)) - (sz - weekday(sz))) // 7) % interval == 0
	end
	if freq == "monthly" then return d == sd and ((y - sy) * 12 + (m - sm)) % interval == 0 end
	if freq == "yearly" then return m == sm and d == sd and (y - sy) % interval == 0 end
	return z == sz
end

-- Events (the drag-calendar plugin's data.json "events") on each day of [from, to] ("YYYY-MM-DD"):
-- { ["2026-11-03"] = { {time, end, title, color, allDay, done, kind = "event"}, ... } }, sorted by time.
function M.expandEvents(events, from, to)
	local days = {}
	local z1, z2 = dayNum(parseDate(from)), dayNum(parseDate(to))
	for _, ev in ipairs(events or {}) do
		for z = z1, z2 do
			local date = fmtDate(z)
			if occursOn(ev, z) and not contains(ev.exdates, date) then
				days[date] = days[date] or {}
				table.insert(days[date], {
					time = ev.allDay and "" or (tostring(ev.start):match("T(%d%d:%d%d)") or ""),
					["end"] = ev.allDay and "" or (tostring(ev["end"] or ""):match("T(%d%d:%d%d)") or ""),
					title = ev.title or "", color = ev.color or "", allDay = ev.allDay and true or false,
					done = contains(ev.doneDates, date), kind = "event",
				})
			end
		end
	end
	for _, list in pairs(days) do
		table.sort(list, function(a, b)
			if a.time ~= b.time then return a.time < b.time end
			return a.title < b.title
		end)
	end
	return days
end

-- The text of a task: everything before the first Tasks-plugin marker (due, scheduled, start, created, recurrence, priority).
local function taskText(rest)
	local cut = #rest + 1
	for _, mark in ipairs({ "📅", "⏳", "🛫", "➕", "🔁", "⏫", "🔼", "🔽", "✅", "❌", "(@", " ^lb-" }) do
		local at = rest:find(mark, 1, true)
		if at and at < cut then cut = at end
	end
	return trim(rest:sub(1, cut - 1))
end

-- Open tasks from grep-style lines ("file:line:- [ ] text 📅 2026-11-05"): the dated ones from anywhere,
-- the undated ones only from the inbox. Dated first, soonest first.
function M.parseTasks(lines)
	local todos = {}
	for _, l in ipairs(lines) do
		local file, rest = l:match("^(.-):%d+:%s*%- %[ %] (.*)$")
		if file then
			local due = rest:match("📅%s*(%d%d%d%d%-%d%d%-%d%d)")
			local text = taskText(rest)
			local time = rest:match("%(@%d%d%d%d%-%d%d%-%d%d (%d%d:%d%d)%)")
			local id = rest:match("%^lb%-(%w+)%s*$")
			if text ~= "" and (due or file:sub(-#M.TODO_FILE) == M.TODO_FILE) then
				todos[#todos + 1] = { text = text, due = due or "", time = time or "", id = id or "" }
			end
		end
	end
	table.sort(todos, function(a, b)
		if (a.due == "") ~= (b.due == "") then return a.due ~= "" end
		if a.due ~= b.due then return a.due < b.due end
		return a.text < b.text
	end)
	return todos
end

-- Tick the todo with this id in the inbox, as a done mark from the phone or the notification asks for.
-- Returns the new text and whether the line was found (and still open).
function M.tick(text, id, date)
	local found = false
	local out = text:gsub("[^\n]*%^lb%-" .. id .. "[^\n]*", function(line)
		if line:find("^%s*%- %[ %] ") then
			found = true
			local done = line:gsub("^(%s*%- )%[ %]", "%1[x]", 1)
			if date and date ~= "" and not done:find("✅", 1, true) then
				done = done:gsub(" %^lb%-" .. id, " ✅ " .. date .. " ^lb-" .. id, 1)
			end
			return done
		end
	end)
	return out, found
end

function M.tickInbox(root, id, date)
	local path = root .. "/" .. M.TODO_FILE
	local text = read(path)
	if not text then return false end
	local out, found = M.tick(text, id, date)
	if found then write(path, out) end
	return found
end

-- The ids of lbrain todos ticked in the inbox (in Obsidian, say): the server has to hear they're done.
function M.tickedIds(root)
	local text = read(root .. "/" .. M.TODO_FILE) or ""
	local ids = {}
	for line in (text .. "\n"):gmatch("(.-)\n") do
		if line:find("^%s*%- %[[xX]%] ") then
			local id = line:match("%^lb%-(%w+)%s*$")
			if id then ids[#ids + 1] = id end
		end
	end
	return ids
end

function M.scanTasks(root)
	local cmd = string.format("grep -rnE --include='*.md' --exclude-dir=.obsidian --exclude-dir=.git --exclude-dir='2-Areas.~1~' '^[[:space:]]*- \\[ \\] ' %q 2>/dev/null", root)
	local p = io.popen(cmd)
	if not p then return {} end
	local lines = {}
	for l in p:lines() do
		if l:find("📅", 1, true) or l:find(M.TODO_FILE, 1, true) then lines[#lines + 1] = l end
	end
	p:close()
	return M.parseTasks(lines)
end

-- Everything the calendar shows, from the month before `ym` ("2026-11") through the month after it:
-- { month, from, to, days = { date = {entries} }, todos = { {text, due} } }. Dated todos also appear on their day.
function M.snapshot(events, todos, ym)
	local y, m = ym:match("^(%d%d%d%d)-(%d%d)$")
	y, m = tonumber(y), tonumber(m)
	local from = fmtDate(dayNum(y, m, 1) - 1):sub(1, 7) .. "-01"
	local nextMonth = dayNum(m == 12 and y + 1 or y, m == 12 and 1 or m + 1, 1)
	local after = fromDayNum(nextMonth)
	local _, am = fromDayNum(nextMonth)
	local ay = after
	local to = fmtDate(dayNum(am == 12 and ay + 1 or ay, am == 12 and 1 or am + 1, 1) - 1)
	local days = M.expandEvents(events, from, to)
	for _, t in ipairs(todos) do
		if t.due ~= "" and t.due >= from and t.due <= to then
			days[t.due] = days[t.due] or {}
			table.insert(days[t.due], { time = "", ["end"] = "", title = t.text, color = "", allDay = true, done = false, kind = "task" })
		end
	end
	return { month = ym, from = from, to = to, days = days, todos = todos }
end

return M
