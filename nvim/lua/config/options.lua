-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Shift+arrows start a selection from insert mode (shown as "-- (insert) VISUAL --"); y/d/c
-- operate on it and return to insert. This replaces the insert-mode defaults of Shift+Left/Right
-- (word jump, still available on Ctrl+Left/Right) and Shift+Up/Down (page scroll).
vim.opt.keymodel = "startsel,stopsel"
