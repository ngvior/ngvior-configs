-- Ruido que no queremos ver nunca, ni en el picker ni en el árbol.
-- El globber de snacks hace `file:find(patrón)` SIN anclar
-- (picker/util/init.lua:672), así que un nombre pelado matchea en cualquier
-- parte del path.
local exclude = {
  ".git/",
  "node_modules",
  "dist/",
  "build/",
  ".next/",
  ".turbo/",
  ".cache/",
  "coverage/",
}

return {
  "folke/snacks.nvim",
  opts = {
    -- Va en `picker` a nivel raíz, NO en `explorer`: `opts.explorer` es
    -- snacks.explorer.Config, que solo tiene `replace_netrw` y `trash`.
    picker = {
      -- hidden: muestra dotfiles. ignored: muestra lo que .gitignore excluye.
      -- Los dos en true a propósito: `.env` y `.env.local` están gitignoreados
      -- y los necesitamos ver. El ruido real se saca por `exclude`, que es
      -- quirúrgico, en vez de por `ignored = false`, que barre con TODO lo
      -- gitignoreado — incluidos los .env.
      hidden = true,
      ignored = true,
      exclude = exclude,
      sources = {
        -- El merge del picker es defaults -> opts.picker -> sources[source]
        -- (picker/config/init.lua:65), o sea que `sources` GANA sobre lo de
        -- arriba. Y snacks trae `M.files` con hidden=false, ignored=false
        -- (picker/config/sources.lua:205). Sin repetirlo acá, <leader>ff
        -- nunca ve los .env aunque la config global diga true.
        -- `explorer` y `grep` no los definen, así que heredan de arriba.
        files = { hidden = true, ignored = true },
      },
    },
    styles = {
      -- Terminal estilo VSCode: pegado abajo y 30% de alto, en vez del
      -- flotante que trae snacks por defecto.
      --
      -- `opts.styles.<nombre>` es la superficie documentada para overridear un
      -- style, y gana sobre los defaults del plugin: snacks/init.lua:131 hace
      -- tbl_deep_extend("force", defaults, config.styles[name]).
      terminal = {
        position = "bottom",
        height = 0.3,
      },
    },
  },
}
