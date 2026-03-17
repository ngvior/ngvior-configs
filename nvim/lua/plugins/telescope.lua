return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- Forzamos a que leader+f+f use find_files, que SI respeta los ignore_patterns
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
  },
  opts = {
    defaults = {
      file_ignore_patterns = {
        "node_modules/.*",
        "dist/.*",
        "%.git/",
        "%.cache",
        "bin",
      },
    },
  },
}
