-- vim.api.nvim_create_user_command("Format", function()
-- 	local bufnr = vim.fn.bufnr("%")

-- 	-- vim.cmd([[
-- 	-- 	normal! gg=G``
-- 	-- 	let currPos = getpos(".")
-- 	-- 	execute '%s/\s\+$//e'
-- 	-- 	execute '%s/\n\+\%$//e'
-- 	-- 	execute '%s/\%$/\r/e'
-- 	-- 	call cursor(currPos[1], currPos[2])
-- 	-- 	]])
-- 	-- Check if LSP is attached to the current buffer
-- 	-- if vim.lsp.get_clients() ~= nil then
-- 	-- 	-- vim.lsp.buf.format(nil, 10000)
-- 	-- 	vim.lsp.buf.format({
-- 	-- 			filter = function(client)
-- 	-- 					-- only use null-ls for formatting instead of lsp server
-- 	-- 					return client.name == "null-ls"
-- 	-- 				end,
-- 	-- 				bufnr = bufnr,
-- 	-- 				timeout_ms = 2000,
-- 	-- 			})
-- 	-- 			-- vim.cmd("let v = winsaveview()")
-- 	-- 			-- vim.lsp.buf.format()
-- 	-- 			-- vim.cmd("call winrestview(v)")
-- 	-- 			-- -- TODO
-- 	-- 			-- -- vim.cmd('normal! ``')
-- 	-- 		else
-- 	-- 			vim.cmd("normal! gg=G``")
-- 	-- 		end

-- 	-- INFO: conform
-- 	require("conform").format({
-- 		lsp_fallback = true,
-- 		async = false,
-- 		timeout_ms = 10000,
-- 	})
-- end, { nargs = 0 })

-- Create the DeleteEmptyLinesInVisual command
vim.api.nvim_create_user_command("DeleteEmptyLinesInVisual", function()
	-- Get the start and end lines of the visual selection
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	-- Check if there's an actual visual selection
	if start_line == end_line then
		print("No visual selection detected!")
		return
	end

	-- Delete empty lines in the selected range
	vim.cmd(start_line .. "," .. end_line .. "g/^$/d")
end, { range = true })

vim.api.nvim_create_user_command("Compile", function()
	vim.cmd('!compiler "%"')
end, { nargs = 0 })

vim.api.nvim_create_user_command("Arabic", function()
	if vim.o.rl then
		vim.o.rl = false
		vim.o.keymap = ""
	else
		vim.o.rl = true
		vim.o.keymap = "arabic"
		vim.o.arabicshape = true
		vim.g.nospell = true
	end
end, { nargs = 0 })

-- doesn't work
-- vim.api.nvim_create_user_command("Evalregion", function()
-- 	-- Get the start and end position of the visual selection
-- 	local start_line = vim.fn.line("'<")
-- 	local end_line = vim.fn.line("'>")

-- 	-- Retrieve the selected lines
-- 	local lines = vim.fn.getline(start_line, end_line)

-- 	-- Concatenate lines into a single string
-- 	local lua_code = table.concat(lines, "\n")

-- 	-- Evaluate the Lua code
-- 	local success, result = pcall(load(lua_code))
-- 	if success then
-- 		print(result)
-- 	else
-- 		print("Error executing Lua code: " .. result)
-- 	end
-- end, { nargs = 0 })
