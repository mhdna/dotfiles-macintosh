-- Disable built-in SQL completion mappings that use <C-c> as prefix.
-- They intercept <C-c> in insert mode, preventing it from exiting insert mode
-- and causing the "-- INSERT --" indicator to linger in the cmdline.
local mappings = {
  "<C-C>a", "<C-C>k", "<C-C>f", "<C-C>o", "<C-C>T", "<C-C>s",
  "<C-C>t", "<C-C>p", "<C-C>v", "<C-C>c", "<C-C>l", "<C-C>L",
  "<C-C>R",
}
for _, lhs in ipairs(mappings) do
  pcall(vim.keymap.del, "i", lhs, { buffer = true })
end
