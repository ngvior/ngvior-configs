return {
  "3rd/diagram.nvim",
  dependencies = {
    {
      "3rd/image.nvim",
      -- The magick_cli processor shells out to ImageMagick, so there is no
      -- luarock to build.
      build = false,
      opts = {
        -- Ghostty implements the Kitty graphics protocol.
        backend = "kitty",
        processor = "magick_cli",
        -- image.nvim refuses to draw anything past the window's botline, and
        -- each diagram reserves this share of the window as virtual padding.
        -- At the 50% default a single tall diagram pushes every later one out
        -- of the viewport, so they never render.
        max_height_window_percentage = 35,
      },
    },
  },
  ft = { "markdown" },
  opts = {
    events = {
      -- TextChanged is deliberately left out. diagram.nvim appends to its
      -- internal diagram list on every render and never removes the old
      -- entries, so re-rendering per keystroke piles up stale image objects
      -- that fight over the same screen rows.
      render_buffer = { "InsertLeave", "BufWinEnter" },
      clear_buffer = { "BufLeave" },
    },
    renderer_options = {
      mermaid = {
        theme = "dark",
        background = "transparent",
        scale = 2,
        -- Ubuntu 24.04 sets kernel.apparmor_restrict_unprivileged_userns=1,
        -- which stops the Chromium that mmdc drives from starting its own
        -- sandbox. Pinning an AppArmor profile instead is not practical: the
        -- browser lives under a version-stamped puppeteer cache path that
        -- changes on every Chromium bump.
        --
        -- mmdc takes this through a puppeteer config file; it rejects a bare
        -- --no-sandbox flag, despite what the diagram.nvim README suggests.
        cli_args = { "-p", vim.fn.stdpath("config") .. "/puppeteer-config.json" },
      },
    },
  },
  keys = {
    {
      "<leader>md",
      function()
        require("diagram").show_diagram_hover()
      end,
      mode = "n",
      ft = { "markdown" },
      desc = "Diagram: open the one under the cursor in a new tab",
    },
  },
}
