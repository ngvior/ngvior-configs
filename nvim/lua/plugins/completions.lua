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
        -- El extra lazyvim.plugins.extras.ai.copilot deja accept = false porque
        -- espera que Copilot se acepte desde el menú de blink.cmp. Como abajo lo
        -- sacamos de las sources de blink para usar solo el ghost text, hay que
        -- devolverle una tecla de aceptar: sin esto la sugerencia aparece y no
        -- hay forma de tomarla.
        -- Teclado es-latam: en este layout `{` y `}` son los caracteres base y
        -- `[` y `]` piden Shift, al revés que en us. Los defaults de copilot.lua
        -- (<M-[>, <M-]>, <C-]>) obligarían a un Shift extra en cada pulsación.
        -- `alt+c` para descartar evita el Shift de <C-]> y no choca con los
        -- alt+h/j/k/l/v/d que captura herdr antes de que lleguen a nvim.
        keymap = {
          accept = "<M-l>",
          next = "<M-}>",
          prev = "<M-{>",
          dismiss = "<M-c>",
        },
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
      -- herdr usa `ctrl+space` como prefix (~/.config/herdr/config.toml:34),
      -- así que el <C-space> del preset "enter" de blink nunca llega a nvim
      -- adentro de herdr. NO cambiamos el prefix de herdr: vale para todo el
      -- workspace, está elegido a propósito y ya es memoria muscular. Movemos
      -- el disparador manual del menú, que es una tecla en una sola app.
      --
      -- <C-n> es la elección natural: es la tecla NATIVA de vim para completar
      -- en insert, y ya está en el preset como select_next.
      --
      -- El orden de la lista importa. Blink prueba cada acción hasta que una
      -- devuelve truthy: `cmp.show()` devuelve nil si el menú YA está abierto
      -- (blink/cmp/init.lua:67) y true si lo abre (:93). Resultado: con el menú
      -- cerrado <C-n> lo abre, con el menú abierto baja un ítem.
      keymap = {
        ["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
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
    -- Prefijo propio: <leader>c es el grupo "code" de LazyVim, y su <leader>cc
    -- (Run Codelens) se registra como buffer-local al adjuntarse el LSP, así que
    -- ganaba siempre y CopilotChat nunca llegaba a mapearse.
    keys = {
      { "<leader>a", "", desc = "+ai" },
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat (Float)" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "CopilotChat (Explain code)" },
    },
  },

  -- RECOMENDACIÓN EXTRA: Friendly Snippets
  -- Blink lo usa para darte sugerencias de código predefinidas (loops, ifs, etc.)
  { "rafamadriz/friendly-snippets" },
}
