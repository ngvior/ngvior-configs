return {
  -- 1. Copilot.lua (El motor de la IA)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
      panel = { enabled = false },
    },
  },
  -- 2. Blink.cmp (El motor de completado ultra rápido)
  {
    "saghen/blink.cmp",
    opts = {
      -- Sacamos a Copilot de acá para que solo use el ghost text de copilot.lua
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      -- Configuración de apariencia
      completion = {
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
      },
    },
  },

  -- 3. Copilot Chat (Para hablar con tu código)
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      debug = false,
      window = {
        layout = "float",
        relative = "editor",
        width = 0.8,
        height = 0.8,
        border = "rounded",
      },
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat (Float)" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat (Explain code)" },
    },
  },

  -- RECOMENDACIÓN EXTRA: Friendly Snippets
  -- Blink lo usa para darte sugerencias de código predefinidas (loops, ifs, etc.)
  { "rafamadriz/friendly-snippets" },
}
