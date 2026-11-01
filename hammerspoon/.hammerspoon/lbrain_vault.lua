-- lbrain_vault.lua: where a captured item goes in the Obsidian vault, and what its Anki card looks
-- like. Pure Lua (no hs.*), so tests/lbrain_vault_test.lua runs it with plain `lua`.

local M = {}

M.DECKS = {
	en_word = "TODO Language::[English] Words",
	en_phrase = "TODO Language::[English] Phrases",
	ar_word = "TODO Language::[Arabic] Words",
	ar_phrase = "TODO Language::[Arabic] Phrases",
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
function M.cardLine(item, date, audioName)
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
	return line
end

function M.appendCard(root, item, date, audioName)
	local file = M.FILES[item.kind]
	if not file then return nil, "no file for " .. tostring(item.kind) end
	local path = root .. "/" .. file
	local text = read(path) or ""
	if text ~= "" and text:sub(-1) ~= "\n" then text = text .. "\n" end
	return write(path, text .. M.cardLine(item, date, audioName) .. "\n")
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
function M.ankiNote(item, audioName)
	local deck = M.DECKS[item.kind]
	if not deck then return nil end
	local back = html(item.back)
	if (item.example or "") ~= "" then back = back .. "<br><br><i>" .. html(item.example) .. "</i>" end
	if (item.topic or "") ~= "" then back = back .. "<br><br>" .. html(item.topic) end
	if audioName then back = back .. "<br>[sound:" .. audioName .. "]" end
	return {
		deckName = deck,
		modelName = "Basic",
		fields = { Front = html(item.text), Back = back },
		options = { allowDuplicate = false, duplicateScope = "deck" },
		tags = { "lbrain", item.kind },
	}
end

-- Where an item with this kind/target goes: "card", "news", "journal" or "inbox".
function M.destination(item)
	if M.DECKS[item.kind] then return "card" end
	if item.kind == "news" or item.kind == "journal" then return item.kind end
	if item.kind == "voice" then
		if item.target == "news" or item.target == "journal" then return item.target end
		return "inbox"
	end
	return "inbox"
end

return M
