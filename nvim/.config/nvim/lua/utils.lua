local M = {}
-- delete empty lines
-- vim.keymap.set('v', '<leader>D', ':g/^$/d<CR>:nohl<CR>', opts)
-- M.squeeze_blank_lines = function()
-- -- references: https://vi.stackexchange.com/posts/26304/revisions
--     if vim.bo.binary == false and vim.opt.filetype:get() ~= "diff" then
--         local old_query = vim.fn.getreg("/") -- save search register
--         M.preserve("sil! 1,.s/^\\n\\{2,}/\\r/gn") -- set current search count number
--         local result = vim.fn.searchcount({ maxcount = 1000, timeout = 500 }).current
--         local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--         M.preserve("sil! keepp keepj %s/^\\n\\{2,}/\\r/ge")
--         M.preserve("sil! keepp keepj %s/\\v($\\n\\s*)+%$/\\r/e")
--         if result > 0 then
--             vim.api.nvim_win_set_cursor({ 0 }, { (line - result), col })
--         end
--         vim.fn.setreg("/", old_query) -- restore search register
--     end
-- end

function M.Compile(prog, _flags)
	_flags = _flags or ""

	if not vim.fn.executable(prog) then
		vim.api.nvim_err_writeln(prog .. "isn't found in PATH")
	end

	local term_buf_exists = false
	local term_bufnr

	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if vim.fn.buflisted(buf.bufnr) == 1 and vim.fn.bufname(buf.bufnr):find("^term://") then
			term_buf_exists = true
			term_bufnr = buf.bufnr
			break
		end
	end

	if term_buf_exists then
		vim.cmd(term_bufnr .. "bdelete!")
	end

	vim.cmd("botright new")
	vim.cmd("execute 'resize ' . " .. 15)
	vim.cmd(string.format("term %s %s", prog, _flags))
	vim.cmd("startinsert")
end

function M.IsInstalled(plugin)
	if pcall(require, plugin) then
		return true
	else
		return false
	end
end

return M
