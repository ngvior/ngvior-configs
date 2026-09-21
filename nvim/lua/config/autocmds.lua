-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable the spell checker and diagnostics in Markdown buffers only.
-- `vim.diagnostic.enable(false)` without a filter is GLOBAL: it would kill
-- diagnostics for every buffer in the session, so the buffer filter is required.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function(event)
    vim.opt_local.spell = false
    vim.diagnostic.enable(false, { bufnr = event.buf })
  end,
})
