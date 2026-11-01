-- Run: lua hammerspoon/tests/lbrain_vault_test.lua   (from the dotfiles-mac folder)
package.path = "hammerspoon/.hammerspoon/?.lua;" .. package.path
local V = require("lbrain_vault")

local failures = 0
local function eq(got, want, name)
	if got ~= want then
		failures = failures + 1
		print("FAIL " .. name .. "\n  got:  " .. tostring(got):gsub("\n", "\\n") .. "\n  want: " .. tostring(want):gsub("\n", "\\n"))
	end
end

-- insertUnder: an existing section, before the next heading, with blank lines kept after
eq(V.insertUnder("# T\n## 2026-10-07 \nfirst\n\n## 2026-10-08\nsecond\n", "## 2026-10-07", "- new"),
	"# T\n## 2026-10-07 \nfirst\n- new\n\n## 2026-10-08\nsecond\n", "insert in middle section")
-- the last section runs to the end of the file
eq(V.insertUnder("# T\n## 2026-10-08\nsecond\n", "## 2026-10-08", "- new"), "# T\n## 2026-10-08\nsecond\n- new\n", "insert in last section")
-- a missing heading is added at the end, after a blank line
eq(V.insertUnder("# T\nstuff\n", "## 2026-11-01", "- x"), "# T\nstuff\n\n## 2026-11-01\n- x\n", "new heading")
eq(V.insertUnder("", "## d", "- x"), "## d\n- x\n", "empty file")
-- a subheading belongs to its section; a higher-level heading ends it
eq(V.insertUnder("## Journal\n### sub\nx\n# Top\n", "## Journal", "- n"), "## Journal\n### sub\nx\n- n\n# Top\n", "higher heading ends it")
-- an empty section
eq(V.insertUnder("## Journal\n## Tasks\n", "## Journal", "- n"), "## Journal\n- n\n## Tasks\n", "empty section")

-- cardLine
eq(V.cardLine({ text = "solidarity", back = "unity", example = "They stood in solidarity.", topic = "" }, "2026-11-01"),
	"- **solidarity** — unity (e.g. They stood in solidarity.) _(2026-11-01)_", "card line")
eq(V.cardLine({ text = "a\nb", back = "", topic = "go" }, "2026-11-01", "v1.m4a"), "- **a b** _(go, 2026-11-01)_ ![[v1.m4a]]", "card line with audio, multi-line")

-- ankiNote
local n = V.ankiNote({ kind = "ar_word", text = "طفرانة <b>", back = "broke", example = "", topic = "" }, nil)
eq(n.deckName, "TODO Language::[Arabic] Words", "deck")
eq(n.fields.Front, "طفرانة &lt;b&gt;", "front escaped")
eq(n.fields.Back, "broke", "back")
eq(V.ankiNote({ kind = "news", text = "x" }), nil, "news is no card")
eq(V.ankiNote({ kind = "info", text = "x", back = "y", topic = "history" }, "a.m4a").fields.Back, "y<br><br>history<br>[sound:a.m4a]", "info back with audio")

-- destination
eq(V.destination({ kind = "en_word" }), "card", "dest card")
eq(V.destination({ kind = "voice", target = "news" }), "news", "dest voice news")
eq(V.destination({ kind = "voice", target = "inbox" }), "inbox", "dest voice inbox")
eq(V.destination({ kind = "voice" }), "inbox", "dest voice default")

-- files: a scratch vault with the real template shape
local root = os.tmpname()
os.remove(root)
os.execute("mkdir -p '" .. root .. "/Sources/Templates'")
V.write(root .. "/Sources/Templates/Diary day note.md", "---\nx:\n---\n# {{date}} - {{time}}\nconst d = \"{{date:YYYY-MM-DD}}\"\n## Journal\n## Tasks\n")
assert(V.appendJournal(root, "2026-11-01", "09:30", "first thought\nsecond line"))
eq(V.read(V.dayPath(root, "2026-11-01")), "---\nx:\n---\n# 2026-11-01 - 09:30\nconst d = \"2026-11-01\"\n## Journal\n- first thought\n  second line\n## Tasks\n", "journal from template")
assert(V.appendJournal(root, "2026-11-01", "10:00", "again"))
eq(V.read(V.dayPath(root, "2026-11-01")):match("## Journal\n(.-)## Tasks"), "- first thought\n  second line\n- again\n", "journal appends")
assert(V.appendNews(root, "2026-11-01", "big news"))
eq(V.read(V.newsPath(root)), "# Events & News\n\n## 2026-11-01\n- big news\n", "news file created")
assert(V.appendCard(root, { kind = "en_word", text = "solidarity", back = "unity" }, "2026-11-01"))
assert(V.appendCard(root, { kind = "en_word", text = "bridle", back = "restrain" }, "2026-11-01"))
eq(V.read(root .. "/LBrain/English words.md"), "- **solidarity** — unity _(2026-11-01)_\n- **bridle** — restrain _(2026-11-01)_\n", "card file appends")
assert(V.appendInbox(root, { text = "idea" }, "2026-11-01", "11:00"))
eq(V.read(root .. "/LBrain/Inbox.md"), "- 2026-11-01 11:00 — idea\n", "inbox")
os.execute("rm -rf '" .. root .. "'")

if failures > 0 then
	print(failures .. " failed")
	os.exit(1)
end
print("ok")
