return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Esto le dice a LazyVim qué linters usar por tipo de archivo
      linters_by_ft = {
        -- Al dejarlo como una tabla vacía, desactivamos markdownlint-cli2
        markdown = {},
      },
    },
  },
}
