local notes_dir = os.getenv("NOTES_DIR")
local notes_dir_public = notes_dir .. "/public"
local notes_dir_private = notes_dir .. "/private"
local todo_dir = notes_dir_private .. "/todo"
local language_dir = notes_dir_public .. "/language"
local ls = require("luasnip")

function AddHeading(heading)
	print("Adding Heading " .. heading)
	vim.cmd("normal! gg0i" .. heading)
end

function CheckOrCreateDir(dir)
	local success, err = os.execute("mkdir -p " .. dir)
	if not success then
		print("Failed to create directory: " .. err)
	end
end

function JumpToHeading(heading)
	heading = "# " .. heading
	local found = vim.fn.search(heading, "w")
	if found == 0 then
		AddHeading(heading)
	end
end

function InsertItem(dir, filename, heading, snip)
	CheckOrCreateDir(dir)
	local isanki = false
	if string.sub(filename, 1, 4) == "anki" then
		isanki = true
	end

	local file_path = dir .. "/" .. filename
	vim.cmd("edit " .. file_path)

	if isanki then
		-- override file content
		vim.cmd('normal ggVGd')
	end

	if heading then
		JumpToHeading(heading)
	else
		vim.cmd("normal! G")
	end

	if snip == nil then
			vim.cmd("normal! o- ")
			vim.api.nvim_feedkeys("a", "n", true)
	else
		if isanki then
			vim.cmd("normal! i" .. snip .. " ")
		else
			vim.cmd("normal! o" .. snip .. " ")
		end
		ls.expand()
	end
end

-- function JumpToFile(dir, filename)
	-- 	vim.cmd("edit " .. dir .. "/" .. filename)
	-- end

	vim.keymap.set("n", "<M-t>", function()
		vim.cmd("edit " .. todo_dir .. "/todo.txt")
	end)

-- vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = 'Search Git Files' })
local keymap_definitions = {
	{ "d", notes_dir_private, "diary.md", false, "dj" },
	{ "j", notes_dir_private, "journal.md", false, "dj" },
	{ "m", notes_dir_private, "movies.md", false, "movie" },
	{ "n", notes_dir_private, "news.md", false, "news" },
	{ "p", notes_dir_public, "project-idea.md", "Project idea", "itemtag" },
	{ "q", notes_dir_public, "questions.md", false, "itemtag" },
	{ "u", notes_dir_public, "quotes.md", false, "itemtag" },
	{ "b", notes_dir_public, "books.md", "Books To Read", "itemtag" },
	-- { "e", language_dir, "english-words.md", "English Word", "itemtag", "<M-l>" },
	-- { "E", language_dir, "english-phrases.md", "English Phrases", "itemtag", "<M-l>" },
	-- { "a", language_dir, "arabic-words.md", "Arabic Word", "itemtag", "<M-L>" },
	-- { "A", language_dir, "arabic-phrases.md", "Arabic Phrases", "itemtag", "<M-L>" },
	{ "e", "/tmp", "anki-english-words.anki", false, "english-word" },
	{ "E", "/tmp", "anki-english-phrases.anki", false, "english-phrase" },
	{ "a", "/tmp", "anki-arabic-words.anki", false, "arabic-word" },
	{ "A", "/tmp", "anki-arabic-phrases.anki", false, "arabic-phrase" },
	{ "f", "/tmp", "anki-basic-flashcard.anki", false, "basic" },
}

for _, mapping in ipairs(keymap_definitions) do
	local key = mapping[1]
	local dir = mapping[2]
	local file = mapping[3]
	local tag = mapping[4] or nil
	local snippet = mapping[5] or nil
	-- local moveToKeymap = mapping[6] or nil

	-- Lowercase mapping for InsertItem
	vim.keymap.set("n", "<F1>" .. key, function()
		InsertItem(dir, file, tag, snippet)
	end)

	-- if moveToKeymap ~= nil then
	-- 	vim.keymap.set("n", moveToKeymap, function()
	-- 		JumpToFile(dir, file)
	-- 	end)
	-- else
	-- 	-- Uppercase mapping for JumpToFile
	-- 	vim.keymap.set("n", "<M-" .. key:upper() .. ">", function()
	-- 		JumpToFile(dir, file)
	-- 	end)
	-- end
end

	-- Image link keymap
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "markdown" },
		callback = function()
			local function insert_image_link()
				-- TODO check if local file so that it doesn't have to do all this stuff
				local pix_dir = vim.fn.expand("%:p:h") .. "/.pix"

				if vim.fn.isdirectory(pix_dir) == 0 then
					vim.fn.mkdir(pix_dir, "p")
				end

				local xclip_content = vim.fn.system("xclip -sel c -o"):gsub("[\n\r]", "")
				local filename = xclip_content:match("^.*/(.*)$") -- everything from the last slash till the end
				local title = vim.fn.fnamemodify(filename, ":r")
				local filepath = pix_dir .. "/" .. filename

				local img_md = string.format("![%s](%s)", title, filepath)

				-- Validate URL (basic check for "http" or "https")
				if not xclip_content:match("^http[s]?://") then
					vim.api.nvim_err_writeln("Error: Clipboard content is not a valid URL.")
					return
				end

				-- Insert the new line and the markdown image link
				vim.api.nvim_put({ img_md }, "l", true, true)

				if vim.fn.filereadable(filepath) == 1 then
					vim.api.nvim_echo({ { "File is already there.", "WarningMsg" } }, true, {})
					return
				end

				-- Download the file using wget in the background
				local download_command = string.format('wget -O "%s" "%s"', filepath, xclip_content)
				vim.fn.system(download_command)
				local exit_code = vim.v.shell_error -- Check the exit status of the last shell command

				-- Check for download success by exit code
				if exit_code == 0 then
					vim.api.nvim_echo({ { "Download successful", "WarningMsg" } }, true, {})
					vim.fn.system("nsxiv " .. filepath .. "&")
				else
					vim.api.nvim_err_writeln("Error: Download failed. Exit code: " .. exit_code)
					return
				end

				-- Function to check if the file is downloaded
				-- local function check_download()
					-- 	local file_path = pix_dir .. "/" .. filename

					-- 	if vim.fn.filereadable(file_path) == 1 then
					-- 		vim.api.nvim_echo({ { "done", "WarningMsg" } }, true, {})
					-- 	else
					-- 		-- Retry after 1 second if the file is not yet downloaded
					-- 		vim.defer_fn(check_download, 1000)
					-- 	end
					-- end

					-- Start checking if the file has been downloaded
					-- check_download()
				end

				-- vim.keymap.set("n", "<leader>i", function()
				-- 	insert_image_link()
				-- end, {buffer = 0})
			end,
		})
