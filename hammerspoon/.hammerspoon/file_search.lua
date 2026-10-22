-- cmd+shift+space: quick file search, in the same dark native chooser as the
-- cmd+space app launcher. Opens on the files you added or opened most recently
-- (so a fresh download or screenshot is one keystroke away), and typing
-- narrows to files whose name has every word you typed, best match first.
--
--   return        open the file
--   cmd+return    reveal it in Finder
--   alt+return    copy its path
--
-- Results come from Spotlight's index (mdfind), which is instant, but only
-- inside ROOTS, so the list isn't buried in caches and app support files.
-- The shell command box that used to live on cmd+shift+space is still on
-- ctrl+space (quick_shell.lua).
local menuPosition = require("menu_position")

local HOME = os.getenv("HOME")

-- Folders under $HOME. The list you see before typing is only the personal
-- ones: a code folder adds and rewrites files constantly, which would bury the
-- downloads and screenshots that are the point. Typing searches all of them.
local RECENT_ROOTS = { "Desktop", "Documents", "Downloads", "Pictures", "Movies", "Music" }
local SEARCH_ROOTS = { "Desktop", "Documents", "Downloads", "Code", "Pictures", "Movies", "Music" }
local RECENT_DAYS = 14
local MAX_RESULTS = 60
local MAX_ROWS = 10
local CHOOSER_WIDTH_PERCENT = 40
local DEBOUNCE_SECONDS = 0.08

-- Paths with any of these in them are dropped: build output, vendored code and
-- hidden folders aren't files anyone searches for by name.
local SKIP = {
	"/node_modules/", "/venv/", "/__pycache__/", "/dist/", "/build/", "/target/",
	"/Pods/", "/DerivedData/", "/.Trash/",
}
-- Editor/backup copies such as "kashi.~1~"
local BACKUP_PATTERN = "%.~%d+~"


local M = {}

-- Seconds local time is ahead of UTC (it can change with daylight saving, so
-- it's refreshed on every search rather than once at load).
function M.refreshUtcOffset()
	local now = os.time()
	M.utcOffset = os.time(os.date("*t", now)) - os.time(os.date("!*t", now))
end
M.refreshUtcOffset()

-- "2026-10-22 10:00:52 +0000" (Spotlight prints UTC) -> epoch seconds, or nil
-- for "(null)".
local function toEpoch(text)
	local y, mo, d, h, mi, s = (text or ""):match("^(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
	if not y then
		return nil
	end
	local fields = {
		year = tonumber(y), month = tonumber(mo), day = tonumber(d),
		hour = tonumber(h), min = tonumber(mi), sec = tonumber(s), isdst = false,
	}
	-- os.time reads the fields as local time; shift by the local UTC offset.
	return os.time(fields) + M.utcOffset
end

local function isSkipped(path)
	for _, part in ipairs(SKIP) do
		if path:find(part, 1, true) then
			return true
		end
	end
	if path:find(BACKUP_PATTERN) then
		return true
	end
	-- any hidden file or folder along the way (.git, .cache, .DS_Store, ...)
	return path:find("/%.[^/]") ~= nil
end

-- One mdfind output line -> {path, added, used, modified} (epochs or nil).
-- Attributes come back in the order they were asked for, after the path.
function M.parseLine(line)
	local path, added, used, modified =
		line:match("^(.-)%s+kMDItemDateAdded = (.-)%s+kMDItemLastUsedDate = (.-)%s+kMDItemContentModificationDate = (.-)%s*$")
	if not path then
		return nil
	end
	return { path = path, added = toEpoch(added), used = toEpoch(used), modified = toEpoch(modified) }
end

-- The newest of the given timestamps and what it was ("added" / "opened" /
-- "modified").
local function newest(file, includeModified)
	local best, label = 0, ""
	local function consider(stamp, name)
		if stamp and stamp > best then
			best, label = stamp, name
		end
	end
	consider(file.added, "added")
	consider(file.used, "opened")
	if includeModified then
		consider(file.modified, "modified")
	end
	return best, label
end

-- Sorts parsed files for display. With no words: newest added/opened first.
-- With words: a name that is exactly the text, then names that start with it,
-- then the rest; newest first within each.
function M.rank(files, words)
	local text = table.concat(words, " "):lower()
	local entries = {}
	for _, file in ipairs(files) do
		local stamp, label = newest(file, #words > 0)
		local name = file.path:match("([^/]+)$") or file.path
		local lower = name:lower()
		local tier = 2
		if text ~= "" then
			local stem = lower:gsub("%.[^.]*$", "")
			if lower == text or stem == text then
				tier = 0
			elseif lower:sub(1, #text) == text then
				tier = 1
			end
		end
		entries[#entries + 1] = { file = file, name = name, stamp = stamp, label = label, tier = tier }
	end
	table.sort(entries, function(a, b)
		if a.tier ~= b.tier then
			return a.tier < b.tier
		end
		if a.stamp ~= b.stamp then
			return a.stamp > b.stamp
		end
		return a.file.path < b.file.path
	end)
	return entries
end

-- "5m", "3h", "2d" ...
local function ago(stamp)
	local seconds = math.max(os.time() - stamp, 0)
	if seconds < 90 then
		return "just now"
	elseif seconds < 3600 then
		return math.floor(seconds / 60) .. "m ago"
	elseif seconds < 86400 then
		return math.floor(seconds / 3600) .. "h ago"
	elseif seconds < 86400 * 60 then
		return math.floor(seconds / 86400) .. "d ago"
	end
	return math.floor(seconds / 86400 / 30) .. "mo ago"
end

local function tilde(path)
	if path:sub(1, #HOME) == HOME then
		return "~" .. path:sub(#HOME + 1)
	end
	return path
end

local function escapeForSpotlight(word)
	return (word:gsub('[\\"]', "\\%0"))
end

-- The mdfind predicate: every word somewhere in the file name (case and
-- diacritics ignored), or, with nothing typed, whatever was added or opened
-- lately.
function M.predicate(words)
	if #words == 0 then
		return string.format(
			'(kMDItemDateAdded >= $time.today(-%d) || kMDItemLastUsedDate >= $time.today(-%d)) && kMDItemContentType != "public.folder"',
			RECENT_DAYS, RECENT_DAYS
		)
	end
	local parts = {}
	for _, word in ipairs(words) do
		parts[#parts + 1] = string.format('kMDItemFSName == "*%s*"cd', escapeForSpotlight(word))
	end
	return table.concat(parts, " && ")
end

local function words(query)
	local out = {}
	for word in (query or ""):gmatch("%S+") do
		out[#out + 1] = word
	end
	return out
end

local function searchArgs(wordList)
	local args = {}
	for _, root in ipairs(#wordList == 0 and RECENT_ROOTS or SEARCH_ROOTS) do
		local dir = HOME .. "/" .. root
		if hs.fs.attributes(dir, "mode") == "directory" then
			args[#args + 1] = "-onlyin"
			args[#args + 1] = dir
		end
	end
	for _, attribute in ipairs({ "kMDItemDateAdded", "kMDItemLastUsedDate", "kMDItemContentModificationDate" }) do
		args[#args + 1] = "-attr"
		args[#args + 1] = attribute
	end
	args[#args + 1] = M.predicate(wordList)
	return args
end

function M.choicesFrom(output, wordList)
	local files = {}
	M.refreshUtcOffset()
	for line in (output or ""):gmatch("[^\n]+") do
		local path = line:match("^(.-)%s+kMDItemDateAdded = ")
		if path and not isSkipped(path) then
			files[#files + 1] = M.parseLine(line)
		end
	end
	local choices = {}
	for index, entry in ipairs(M.rank(files, wordList)) do
		if index > MAX_RESULTS then
			break
		end
		local dir = entry.file.path:match("^(.*)/[^/]*$") or ""
		local subText = tilde(dir)
		if entry.stamp > 0 then
			subText = subText .. "  ·  " .. entry.label .. " " .. ago(entry.stamp)
		end
		choices[#choices + 1] = {
			text = entry.name,
			subText = subText,
			path = entry.file.path,
		}
	end
	return choices
end

-- Everything below needs Hammerspoon itself.
if not hs or not hs.chooser then
	return M
end

local generation = 0
local task = nil
local debounce = nil

local function search(query)
	generation = generation + 1
	local mine = generation
	if task and task:isRunning() then
		task:terminate()
	end
	local wordList = words(query)
	task = hs.task.new("/usr/bin/mdfind", function(_, stdout)
		if mine ~= generation then
			return -- a newer search has started
		end
		local choices = M.choicesFrom(stdout, wordList)
		for _, choice in ipairs(choices) do
			choice.image = hs.image.iconForFile(choice.path)
		end
		M.chooser:choices(choices)
	end, searchArgs(wordList))
	task:start()
end

local function pick(choice)
	if not choice or not choice.path then
		return
	end
	local mods = hs.eventtap.checkKeyboardModifiers()
	if mods.cmd then
		hs.task.new("/usr/bin/open", nil, { "-R", choice.path }):start()
	elseif mods.alt then
		hs.pasteboard.setContents(choice.path)
		hs.alert.show("path copied", 0.6)
	else
		hs.task.new("/usr/bin/open", nil, { choice.path }):start()
	end
end

M.chooser = hs.chooser.new(pick)
M.chooser:bgDark(true)
M.chooser:rows(MAX_ROWS)
M.chooser:searchSubText(false)
M.chooser:placeholderText("Find files   (↩ open · ⌘↩ reveal · ⌥↩ copy path)")
M.chooser:queryChangedCallback(function(query)
	if debounce then
		debounce:stop()
	end
	debounce = hs.timer.doAfter(DEBOUNCE_SECONDS, function()
		search(query)
	end)
end)

local function show(initialQuery)
	initialQuery = initialQuery or ""
	M.chooser:query(initialQuery)
	M.chooser:choices({})
	menuPosition.showChooser(M.chooser, CHOOSER_WIDTH_PERCENT)
	search(initialQuery)
end

hs.hotkey.bind({ "cmd", "shift" }, "space", function()
	show("")
end)

-- open hammerspoon://file-search (or ...?q=invoice) from a script or a link
hs.urlevent.bind("file-search", function(_, params)
	show(params and params.q or "")
end)

return M
