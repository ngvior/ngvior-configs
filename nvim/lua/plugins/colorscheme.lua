return {
  {
    "daltonmenezes/aura-theme",
    lazy = false,
    priority = 1000,
    config = function(plugin)
      -- Esto ayuda a Neovim a encontrar el tema dentro del paquete
      vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
      -- Aplicamos el tema
      vim.cmd([[colorscheme aura-dark]])

      -- Ajustamos los colores de las referencias para que veas la letra
      -- local set_hl = vim.api.nvim_set_hl
      -- bg: fondo oscuro violeta, fg: letra blanca
      -- set_hl(0, "LspReferenceText", { bg = "#27a88c", fg = "#000000", bold = true })
      -- set_hl(0, "LspReferenceRead", { bg = "#27a88c", fg = "#000000", bold = true })
      -- set_hl(0, "LspReferenceWrite", { bg = "#27a88c", fg = "#000000", bold = true })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aura-dark",
    },
  },
}
