local M = {}

function M.register_auto_add_comma()
  vim.keymap.set("n", "o", function()
    local line = vim.api.nvim_get_current_line()

    local should_add_comma = string.find(line, "[^,{[]$")
    if should_add_comma then
      return "A,<CR>"
    end

    return "o"
  end, { buffer = true, expr = true })
end

return M
