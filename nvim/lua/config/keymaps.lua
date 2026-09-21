-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- herdr usa `ctrl+space` como prefix (~/.config/herdr/config.toml:34), así que
-- <C-Space> nunca llega a nvim adentro de herdr. Eso rompía DOS cosas:
--   1. el disparador manual del menú de blink -> movido a <C-n> en completions.lua
--   2. la selección incremental de treesitter -> alias acá
--
-- No cambiamos el prefix de herdr: vale para todo el workspace y ya es memoria
-- muscular. `alt+e` está libre tanto en herdr como en GNOME (que solo se queda
-- con alt+space, para activate-window-menu).
vim.keymap.set({ "n", "x", "v" }, "<M-e>", "<C-Space>", {
  remap = true,
  desc = "Treesitter Incremental Selection (alias de <C-Space>, que herdr come)",
})

-- Copiar el path del buffer actual al clipboard del sistema.
--
-- `<leader>f` es el grupo de archivos de LazyVim y `fy`/`fY` están libres.
-- Mayúscula = path absoluto, siguiendo la convención de LazyVim, donde la
-- variante en mayúscula del par amplía el alcance de la minúscula (`ff`/`fF`,
-- `fr`/`fR`).
--
-- Los buffers sin archivo (dashboard de snacks, pickers) devuelven "" en
-- `expand`, así que avisamos en vez de dejar el clipboard en blanco.
local function yank_path(modifier, label)
  return function()
    local path = vim.fn.expand("%:" .. modifier)
    if path == "" then
      vim.notify("El buffer no tiene un archivo asociado", vim.log.levels.WARN)
      return
    end
    vim.fn.setreg("+", path)
    vim.notify(label .. " copiado: " .. path)
  end
end

vim.keymap.set("n", "<leader>fy", yank_path(".", "Path relativo"), { desc = "Copiar path relativo del archivo" })
vim.keymap.set("n", "<leader>fY", yank_path("p", "Path absoluto"), { desc = "Copiar path absoluto del archivo" })

-- Toggle del terminal. LazyVim lo pone en <C-/>, pero en el layout latam `/`
-- es Shift+7, así que `ctrl+/` es en realidad ctrl+shift+7 y la terminal no lo
-- codifica como el ^_ que nvim espera. `alt+t` está libre en nvim, en herdr y
-- en GNOME.
vim.keymap.set({ "n", "t" }, "<M-t>", "<C-/>", {
  remap = true,
  desc = "Toggle terminal (alias de <C-/>, que el layout latam no puede mandar)",
})

-- Salir de modo Terminal a Normal con doble <esc>.
--
-- snacks ya hace esto para SUS terminales (snacks/terminal.lua:51-63), pero es
-- un keymap del buffer de snacks: en un `:terminal` nativo no existe, y ahí la
-- única salida es <C-\><C-n>, que en latam necesita AltGr para la barra.
--
-- Copiamos el patrón de snacks a propósito, en vez de mapear "<Esc><Esc>"
-- derecho: un mapeo de dos teclas haría que un <esc> SUELTO espere los 300 ms
-- de timeoutlen antes de llegar al programa que corre adentro, y eso rompe
-- vim, less o fzf dentro del terminal. Con `expr` devolvemos el <esc> al
-- instante y solo el segundo, si llega antes de 200 ms, sale a normal.
local esc_timer
vim.keymap.set("t", "<esc>", function()
  esc_timer = esc_timer or (vim.uv or vim.loop).new_timer()
  if esc_timer:is_active() then
    esc_timer:stop()
    vim.cmd("stopinsert")
    return ""
  end
  esc_timer:start(200, 0, function() end)
  return "<esc>"
end, { expr = true, desc = "Doble <esc>: modo Terminal -> Normal" })

-- Guardar como: pide el nombre y bautiza el buffer.
--
-- `<leader>fn` (LazyVim) abre un buffer nuevo SIN nombre, así que `:w` no tiene
-- a dónde escribir. La salida nativa es `:sav <ruta>`, pero hay que tipearla
-- entera cada vez.
--
-- Usamos `:saveas` y no `:w <ruta>` a propósito: `:w <ruta>` vuelca el
-- contenido pero deja el buffer sin nombre, así que el siguiente `:w` vuelve a
-- fallar. `saveas` escribe Y renombra el buffer.
--
-- `vim.ui.input` lo toma snacks.input. Precargamos el path actual (o el cwd con
-- la barra final, para buffers sin archivo) y `completion = "file"` habilita
-- <Tab> sobre el filesystem.
--
-- Creamos el directorio padre porque nvim no lo hace y `saveas` fallaría con
-- E212 sobre una carpeta inexistente. No forzamos con `saveas!`: si el archivo
-- ya existe, mejor avisar que pisarlo sin preguntar.

-- nvim no deja que dos buffers apunten al mismo archivo: `saveas` sobre un path
-- ya cargado corta con E139. El buffer culpable puede estar DESCARGADO y no
-- aparecer en la barra (un preview de snacks, algo cerrado con `:bd`, que
-- descarga pero no borra el buffer), así que recorremos `nvim_list_bufs`, que
-- los ve a todos: listados, no listados y descargados.
--
-- Comparamos nombres ya expandidos en vez de usar `bufnr(pattern)`: ese toma
-- una regex, y cualquier `.` o `-` del path haría matches de más.
local function buffer_with_path(path)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == path then
      return buf
    end
  end
end

vim.keymap.set("n", "<leader>fs", function()
  local current = vim.fn.expand("%:p")
  local default = current ~= "" and current or (vim.fn.getcwd() .. "/")

  vim.ui.input({ prompt = "Guardar como: ", default = default, completion = "file" }, function(input)
    if not input or input == "" then
      return
    end

    local path = vim.fn.fnamemodify(input, ":p")

    -- Confirmaste el default sin tocarlo: no hay nada que renombrar, es un `:w`.
    if path == current then
      vim.cmd("write")
      return
    end

    local other = buffer_with_path(path)
    if other and other ~= vim.api.nvim_get_current_buf() then
      vim.notify(
        ("E139: ese archivo ya está en el buffer %d. Cerralo con :bwipeout %d y reintentá."):format(other, other),
        vim.log.levels.ERROR
      )
      return
    end

    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")

    local ok, err = pcall(vim.cmd, "saveas " .. vim.fn.fnameescape(path))
    if not ok then
      vim.notify(tostring(err), vim.log.levels.ERROR)
    end
  end)
end, { desc = "Guardar como (saveas)" })
