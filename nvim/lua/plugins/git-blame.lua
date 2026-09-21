return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  opts = {
    enabled = false,
    message_template = "  <summary> • <date> • <author>",
    date_format = "%Y-%m-%d",
  },
  keys = {
    { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Git Blame: toggle" },
    { "<leader>gu", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Git Blame: abrir URL commit" },
  },
}
