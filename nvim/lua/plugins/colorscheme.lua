return {
  {
    "daltonmenezes/aura-theme",
    lazy = false,
    priority = 1000,
    -- 'init' se ejecuta ANTES de que el plugin se cargue y antes que LazyVim busque el tema
    init = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
    end,
    config = function()
      -- Una vez que el path ya existe, lo activamos
      vim.cmd([[colorscheme aura-dark]])
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- Borramos la línea de colorscheme de acá para que no
      -- intente buscarlo antes de tiempo.
    },
  },
}
