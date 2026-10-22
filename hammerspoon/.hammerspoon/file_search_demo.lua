-- Fake Spotlight output for file_search.lua's screenshots
-- (hammerspoon://file-search?demo=1): believable files with believable dates,
-- so the window can be shown without anyone's real file names in it. The
-- lines have the shape `mdfind -attr` prints, so the real parsing, ranking
-- and drawing code runs on them.
local HOME = os.getenv("HOME")

-- folder, name, minutes since added, minutes since opened (nil = never)
local FILES = {
	{ "Downloads", "Invoice-1043-Almaza.pdf", 6, nil },
	{ "Pictures/Screenshots", "Screenshot 2026-10-22 at 13.31.07.png", 14, nil },
	{ "Downloads", "Q3 sales report.xlsx", 38, 22 },
	{ "Documents", "Invoices 2026.xlsx", 190, 55 },
	{ "Downloads", "Brand guidelines v3.pdf", 95, nil },
	{ "Desktop", "Quarterly review.pptx", 130, nil },
	{ "Downloads", "Receipts-October.zip", 210, nil },
	{ "Documents", "Lease agreement.docx", 600, 260 },
	{ "Pictures/Screenshots", "Screenshot 2026-10-22 at 10.12.44.png", 330, nil },
	{ "Downloads", "Team photo.jpg", 420, nil },
	{ "Desktop", "Meeting notes.md", 500, nil },
	{ "Downloads", "Invoice-1042-Hamra.pdf", 1500, nil },
	{ "Documents", "Budget 2027.xlsx", 2600, 1700 },
	{ "Downloads", "Screen Recording 2026-10-21 at 18.02.31.mov", 1900, nil },
	{ "Documents", "invoice-template.docx", 4300, 2300 },
	{ "Downloads", "Logo-final.svg", 2900, nil },
	{ "Desktop", "Menu draft.pdf", 3400, nil },
	{ "Downloads", "Podcast ep12.mp3", 4300, nil },
	{ "Documents", "Wireframes.fig", 5200, nil },
	{ "Downloads", "backup-2026-10.dmg", 7000, nil },
	{ "Documents", "Supplier contract.pdf", 8200, nil },
	{ "Desktop", "Packing list.csv", 9400, nil },
	{ "Downloads", "Invoice-1041-Verdun.pdf", 3100, nil },
	{ "Downloads", "Invoice-1040-Achrafieh.pdf", 4600, nil },
	{ "Documents", "Invoices 2025.xlsx", 12000, 6100 },
	{ "Downloads", "Invoice-1039-Jounieh.pdf", 6200, nil },
	{ "Pictures", "invoice-logo.png", 14000, nil },
	{ "Downloads", "Invoice-1038-Saida.pdf", 20000, nil },
	{ "Documents", "Invoice reminder email.docx", 21000, nil },
}

local function stamp(minutesAgo)
	if not minutesAgo then
		return "(null)"
	end
	return os.date("!%Y-%m-%d %H:%M:%S +0000", os.time() - minutesAgo * 60)
end

-- The "mdfind output" for the words typed (every word in the name), as one
-- string of lines.
return function(words)
	local lines = {}
	for _, file in ipairs(FILES) do
		local name = file[2]:lower()
		local matches = true
		for _, word in ipairs(words) do
			if not name:find(word:lower(), 1, true) then
				matches = false
				break
			end
		end
		if matches then
			lines[#lines + 1] = string.format(
				"%s/%s/%s   kMDItemDateAdded = %s   kMDItemLastUsedDate = %s   kMDItemContentModificationDate = %s",
				HOME, file[1], file[2], stamp(file[3]), stamp(file[4]), stamp(file[3])
			)
		end
	end
	return table.concat(lines, "\n")
end
