# 🚀 Tu Cheatsheet Definitivo de Neovim / LazyVim

¡Qué bueno que te estés metiendo de lleno con Neovim! Como siempre digo, dominar el editor es como dominar tu propio cerebro; te da superpoderes. Acá tenés un resumen de los atajos más importantes basados en tu configuración actual y en los comportamientos clásicos que estás buscando.

---

## 📋 1. Copiar y Pegar SIN perder texto (El famoso problema de Vim)

En Vim, cuando borrás algo con `d` (delete), `c` (change) o `x` (borrar caracter), ese texto reemplaza lo que tenías copiado en tu portapapeles "fantasma" (el *unnamed register*). 

Para solucionar esto y pegar sin perder lo que copiaste, tenés **tres alternativas excelentes**:

1. **La forma Nativa (Visual Mode):** 
   Si seleccionás texto en Modo Visual y querés pegarle algo encima, en lugar de apretar `p` (minúscula), **apretá `P` (Mayúscula)**. Esto pega el texto y **no** sobrescribe tu portapapeles. ¡Es así de fácil!
   
2. **El Registro "Cero" (El historial de copias):**
   Vim es tan inteligente que guarda lo ÚLTIMO que copiaste (con `y` de yank) en un registro especial llamado `0`. 
   Si borraste texto por error y perdiste tu copia, simplemente apretá `"0p` (comilla doble, cero, p) en Modo Normal. Esto dice: "Pegame lo que copié explícitamente la última vez".

3. **La Solución Definitiva (Atajos personalizados):**
   Si querés que al borrar con la tecla `x` (o seleccionar y borrar) no te ensucie el portapapeles, agregá esto en tu `lua/config/keymaps.lua`:
   ```lua
   -- Evitar que 'x' ensucie el portapapeles (manda al agujero negro "_")
   vim.keymap.set("n", "x", '"_x')
   -- Evitar que pegar en visual mode sobrescriba el portapapeles
   vim.keymap.set("v", "p", '"_dP')
   ```

---

## 🏃‍♂️ 2. Movimientos Estilo Mac (Option + Flechas / Command + Flechas)

En Vim **TODO** se trata de mantener los dedos en el teclado. Olvidate de las flechas. Te aseguro que si te acostumbrás a esto, no volvés más atrás.

### Moverse por Palabra (Como Option + ⬅️ / ➡️)
En **Modo Normal**:
- `w` (word): Salta al **inicio** de la siguiente palabra.
- `e` (end): Salta al **final** de la siguiente palabra.
- `b` (back): Salta hacia **atrás** por palabra.

*Tip de oro:* Si querés saltar palabras que incluyen símbolos (ej. `mi-variable-loca`), usá las mayúsculas: `W`, `E`, `B`.

### Moverse al Principio/Final de la Línea (Como Command + ⬅️ / ➡️)
En **Modo Normal**:
- `0` (Cero): Va al **principio absoluto** de la línea.
- `^`: Va al **primer caracter que no sea un espacio** en la línea (casi siempre querés usar este).
- `$`: Va al **final** de la línea.
- `I` (Mayúscula i): Te lleva al principio y te pone a escribir (Insert Mode).
- `A` (Mayúscula a): Te lleva al final y te pone a escribir (Insert Mode).

---

## 🤖 3. Completions, IA y Copilot (Tus plugins)

Acá tenés una configuración re potente y limpia. Usamos **Copilot** para bloques grandes de código (estilo VSCode) y **Blink** para el autocompletado rápido del lenguaje.

### Copilot (Sugerencias fantasma / Ghost Text):
Aparece texto en gris mientras escribís.
- `<Alt> + Enter` (`<M-CR>`): **Aceptar** la sugerencia.
- `<Alt> + ]`: Ver la **siguiente** sugerencia.
- `<Alt> + [`: Ver la sugerencia **anterior**.
- `<Ctrl> + ]`: **Ocultar** la sugerencia.

### Copilot Chat (Tu ChatGPT en Neovim):
- `<Leader> + c + c`: Abre/Cierra el chat flotante de Copilot.
- `<Leader> + c + e`: Explica el código que tengas seleccionado.

### Blink (El menú autocompletado tradicional):
Te sugiere variables, funciones y rutas de archivos mientras tipeás.
- `<Flecha Abajo>` o `<Ctrl> + n`: Siguiente opción en el menú.
- `<Flecha Arriba>` o `<Ctrl> + p`: Opción anterior.
- `<Enter>` o `<Tab>`: Aceptar la sugerencia de la lista.

---

## 📁 4. Navegación General (LazyVim Essentials)

Al usar LazyVim tenés la tecla `<Leader>` (que por defecto es la barra espaciadora `Space`). Esto te abre un mundo de comandos:

### Archivos y Búsqueda (Telescope)
- `<Space> + f + f`: Buscar archivos por nombre (¡Este lo configuraste vos en `telescope.lua`!).
- `<Space> + s + g`: Live Grep (Busca texto específico DENTRO de todos los archivos de tu proyecto).
- `<Space> + ,` (coma): Lista de archivos que tenés abiertos (Buffers).
- `<Space> + e`: Abrir el árbol de archivos (Neo-tree) a la izquierda.

### Ventanas (Splits)
- `<Ctrl> + w + v`: Partir la pantalla verticalmente.
- `<Ctrl> + w + s`: Partir la pantalla horizontalmente.
- `<Ctrl> + Flechas` (o `<Ctrl> + h/j/k/l`): Moverte entre las pantallas partidas.
- `<Ctrl> + q`: Cerrar la pantalla actual.

### Pestañas de Archivos (Buffers)
- `Shift + h`: Ir al archivo (buffer) anterior.
- `Shift + l`: Ir al archivo (buffer) siguiente.
- `<Space> + b + d`: Cerrar el archivo actual (Buffer Delete).

---

## 💡 Próximos pasos
1. Lee este cheatsheet un par de veces.
2. Empezá a usar `w`, `b`, `^` y `$` en lugar de las flechas. Te va a doler dos días, ¡y después vas a volar!
