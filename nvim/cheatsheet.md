# Cheatsheet de Neovim / LazyVim

Referencia rápida para consultar desde la terminal. La versión completa y buscable
está en `cheatsheet.html`, con notas explicando el porqué de cada cosa.

Todo lo de acá está verificado contra la config corriendo, no escrito de memoria.

## Cómo leer los atajos

| Notación | Qué apretar |
|---|---|
| `<C-o>` | Ctrl + o (una sola vez, las dos teclas juntas) |
| `<M-l>` | Alt + l |
| `<S-l>` | Shift + l |
| `<CR>` | Enter |
| `leader` | Barra espaciadora |
| `<leader>ff` | Espacio, después f, después f (en secuencia, no juntas) |

`leader` es la barra espaciadora. Apretala sola y esperá: which-key te lista todo
lo disponible. Es la única tecla que hace falta memorizar.

**Los pares de navegación viven en corchetes.** `]x` / `[x`, como en `:help` y
en cualquier documentación de vim. En latam piden Shift. Hubo alias en llaves
(`}x` / `{x`) para ahorrarlo, pero se sacaron: convertían a `{` y `}` en prefijo
y eso retrasaba el movimiento por párrafo.

## Modos

| Tecla | Acción |
|---|---|
| `esc` | Volver a normal, y limpia el resaltado de búsqueda |
| `i` / `a` | Insertar antes / después del cursor |
| `I` / `A` | Insertar al principio / final de la línea |
| `o` / `O` | Línea nueva abajo / arriba, y a insertar |
| `v` / `V` | Visual por caracter / por líneas |
| `<C-v>` | Visual en bloque (selección por columnas) |
| `<S-←>` `<S-→>` `<S-↑>` `<S-↓>` | Desde insert: arrancan selección visual (`-- (insert) VISUAL --`) |
| `:` | Línea de comandos |

Normal es la casa. Todas las teclas son comandos ahí. Vas a insert para escribir
y volvés con `esc`. Si una tecla hace algo raro, probablemente estés en el modo
equivocado: apretá `esc`.

**Shift+flechas selecciona sin salir de insert.** `keymodel = "startsel,stopsel"`
(`options.lua`) hace que Shift+flecha arranque una selección visual estando en
insert; `y`/`d`/`c` operan sobre ella y volvés a insert. Reemplaza el default de
insert de Shift+Izquierda/Derecha (salto de palabra, que sigue en Ctrl+←/→) y
Shift+Arriba/Abajo (scroll de página).

## Viniendo de VSCode

| VSCode | Acá |
|---|---|
| `Ctrl+P` | `<leader><space>` |
| `Ctrl+Shift+F` | `<leader>/` |
| `Ctrl+Tab` | `<leader>,` |
| `Ctrl+Shift+E` | `<leader>e` |
| `F12` | `gd` |
| `Shift+F12` | `gr` |
| `F2` | `<leader>cr` |
| `Ctrl+.` | `<leader>ca` |
| `Ctrl+/` | `gcc` |
| `Ctrl+S` | `<C-s>` (misma tecla, anda en insert también) |
| `Ctrl+Shift+G` | `<leader>gg` |
| ``Ctrl+` `` | `<M-t>` |
| `Alt+↑` / `Alt+↓` | `<M-k>` / `<M-j>` |

## Deshacer y rescate

| Tecla | Acción |
|---|---|
| `u` | Deshacer. Este es tu Ctrl+Z |
| `<C-r>` | Rehacer |
| `U` | Deshacer todos los cambios de la última línea tocada |
| `<leader>su` | Undotree: navegar el historial completo |
| `:earlier 10m` | Volver el buffer a cómo estaba hace 10 minutos |
| `:later 5m` | Avanzar de vuelta |
| `:e!` | Recargar del disco, tirando todo lo no guardado |
| `<leader>ghr` | Resetear el hunk bajo el cursor al estado de git |
| `<leader>ghR` | Resetear el buffer entero al estado de git |

## Guardar y salir

| Tecla | Acción |
|---|---|
| `<C-s>` | Guardar |
| `:w` | Escribir |
| `:q` | Cerrar la ventana. Se niega si hay cambios sin guardar |
| `:wq` | Guardar y salir |
| `:q!` | Salir tirando los cambios |
| `<leader>qq` | Salir de todo |
| `<leader>bd` | Cerrar el buffer, manteniendo el layout de ventanas |
| `<leader>fs` | Guardar como: pide la ruta (con `<Tab>` sobre el filesystem) y renombra el buffer |
| `:sav ruta` | Lo mismo a mano: escribe el archivo **y** le pone ese nombre al buffer |

**Un buffer sin nombre no se guarda con `:w`.** `<leader>fn` abre un buffer
vacío y anónimo. Usá `<leader>fs` o `:sav ruta`, no `:w ruta`: ese escribe el
contenido pero deja el buffer sin nombre, y el próximo `:w` vuelve a fallar.
`<leader>fs` además crea el directorio padre si no existe y no pisa un archivo
existente.

**Guardar formatea.** El autoformat está activo: por eso un archivo que solo
abriste puede terminar con diff. `<leader>uf` lo desactiva global, `<leader>uF`
solo para el buffer.

## Moverse dentro del archivo

| Tecla | Acción |
|---|---|
| `h` `j` `k` `l` | Izquierda / abajo / arriba / derecha |
| `w` / `b` | Una palabra adelante / atrás |
| `e` | Al final de la palabra actual |
| `W` `B` `E` | Igual, pero ignorando símbolos (`mi-variable-loca` es una palabra) |
| `0` | Principio absoluto de la línea |
| `^` | Primer caracter que no sea espacio (casi siempre querés este) |
| `$` | Final de la línea |
| `gg` / `G` | Principio / final del archivo |
| `42G` | Ir a la línea 42 |
| `{` / `}` | Párrafo anterior / siguiente |
| `<C-d>` / `<C-u>` | Media pantalla abajo / arriba |
| `%` | Salta al paréntesis o llave que cierra |
| `fx` | Salta a la próxima `x` de esta línea |
| `;` / `,` | Repetir ese salto `f` adelante / atrás |
| `s` | Flash: escribí 2 caracteres y saltá a cualquier lado de la pantalla |
| `zz` | Recentrar la pantalla en el cursor |

**Los contadores multiplican todo.** `5j` son cinco líneas abajo, `3w` tres
palabras, `2dd` borra dos líneas.

**`{` y `}` saltan a la próxima línea vacía**, no "al próximo párrafo". Si
separás bloques con más de una línea en blanco, el primer toque te deja en la
primera vacía y parece que no pasó nada.

## Historial de saltos

| Tecla | Acción |
|---|---|
| `<C-o>` | Volver de donde saltaste, cruzando archivos |
| `<C-i>` | Ir hacia adelante otra vez |
| ` `` ` | Volver a la posición exacta antes del último salto |
| `<C-^>` | Alternar entre los dos últimos buffers |
| `<leader>sj` | Navegar la lista de saltos completa |

`<C-o>` es la tecla que hace que nvim se sienta navegable. Saltás a una
definición, la leés, `<C-o>` y estás de vuelta exactamente donde estabas. Es el
`Alt+←` de VSCode pero funciona entre archivos, búsquedas y greps por igual.

## Editar texto

| Tecla | Acción |
|---|---|
| `x` | Borrar el caracter bajo el cursor |
| `rx` | Reemplazar ese caracter por `x` |
| `dw` | Borrar hasta el final de la palabra |
| `dd` | Borrar la línea entera |
| `ciw` | Cambiar la palabra: la borra y te deja en insert |
| `ci"` | Cambiar todo lo que está entre comillas |
| `ci{` | Cambiar todo lo que está entre llaves |
| `C` | Cambiar del cursor al final de la línea |
| `.` | Repetir el último cambio. Aprendete esta |
| `gcc` | Comentar / descomentar la línea |
| `gc` | Comentar / descomentar la selección |
| `>` / `<` | Indentar / desindentar la selección |
| `<M-e>` | Agrandar la selección por nodo de sintaxis (treesitter) |

**La gramática:** verbo + objeto. `d` borrar, `c` cambiar, `y` copiar. `w`
palabra, `iw` dentro de la palabra, `i"` dentro de las comillas, `ap` un
párrafo. Cualquier verbo combina con cualquier objeto. Ese es todo el truco.

## Copiar, cortar, pegar

| Tecla | Acción |
|---|---|
| `yy` | Copiar la línea |
| `y` | Copiar la selección visual |
| `p` / `P` | Pegar después / antes del cursor |
| `"+y` | Copiar al clipboard del sistema |
| `"+p` | Pegar del clipboard del sistema |
| `<leader>s"` | Ver todos los registros |

**Borrar también copia.** `dd` manda la línea al registro, así que es cortar, no
borrar. Por eso pegar después de borrar funciona.

**El problema clásico: perder la copia al pegar.** Cuando borrás con `d`, `c` o
`x`, ese texto reemplaza lo que tenías copiado en el registro sin nombre. Tres
salidas:

1. En visual, pegá con `P` (mayúscula) en vez de `p`. No sobreescribe tu copia.
2. `"0p` pega lo último que copiaste **explícitamente** con `y`. El registro `0`
   guarda solo los yanks, nunca los borrados.
3. `"_d` borra al agujero negro, sin tocar ningún registro.

## Buscar y reemplazar

| Tecla | Acción |
|---|---|
| `/texto<CR>` | Buscar hacia adelante en el archivo |
| `?texto<CR>` | Buscar hacia atrás |
| `n` / `N` | Coincidencia siguiente / anterior |
| `*` | Buscar la palabra bajo el cursor |
| `esc` | Limpiar el resaltado |
| `:%s/viejo/nuevo/g` | Reemplazar en todo el archivo |
| `:%s/viejo/nuevo/gc` | Igual, confirmando cada uno |
| `<leader>/` | Grep en todo el proyecto |
| `<leader>sw` | Grep de la palabra bajo el cursor |
| `<leader>sr` | Buscar y reemplazar entre archivos (grug-far) |
| `<leader>sR` | Reabrir el último picker donde lo dejaste |

## Archivos y buffers

| Tecla | Acción |
|---|---|
| `<leader><space>` | Buscar archivo en la raíz del proyecto |
| `<leader>ff` | Buscar archivos (raíz) |
| `<leader>fF` | Buscar archivos (directorio actual) |
| `<leader>fr` | Archivos recientes |
| `<leader>fg` | Buscar solo entre archivos trackeados por git |
| `<leader>,` | Cambiar de buffer |
| `<leader>e` | Árbol de archivos en la raíz del proyecto |
| `<leader>E` | Árbol en el directorio actual |
| `H` / `L` | Buffer anterior / siguiente |
| `<leader>bd` | Cerrar este buffer |
| `<leader>fn` | Archivo nuevo (sin nombre: guardalo con `<leader>fs`) |
| `<leader>fs` | Guardar como / ponerle nombre al buffer |
| `<leader>fc` | Saltar a tu propia config de nvim |
| `<leader>fp` | Cambiar de proyecto |
| `<leader>fy` | Copiar el path **relativo** del archivo al clipboard |
| `<leader>fY` | Copiar el path **absoluto** del archivo al clipboard |
| `gx` | Abrir la URL o path bajo el cursor en la app del sistema |
| `:ls!` | Listar **todos** los buffers, incluidos los ocultos y descargados |
| `:bwipeout 7` | Borrar del todo el buffer 7 (`:bd` solo lo descarga) |

**Dentro de cualquier picker:** escribí para filtrar, `<C-j>`/`<C-k>` o flechas
para moverte, `<CR>` para abrir, `<C-v>` para abrir en split vertical, `esc`
para cerrar.

**`<leader>e` togglea, no enfoca.** Desde un archivo, te cierra el árbol. Para
pasar del código al árbol sin cerrarlo usá `<C-h>`, y `<C-l>` para volver.

Los `.env` y `.env.local` **sí** aparecen, aunque estén gitignoreados.
`node_modules`, `dist`, `build`, `.next`, `.turbo`, `.cache` y `coverage` no.

## Terminal

| Tecla | Acción |
|---|---|
| `<M-t>` | Toggle de una terminal abajo. De nuevo para ocultarla |
| `<leader>ft` | La misma terminal, en la raíz del proyecto |
| `<leader>fT` | Terminal en el directorio del archivo actual |
| `esc` `esc` | Modo Terminal a Normal, para poder scrollear y copiar |
| `q` | Ocultar la terminal (desde normal, después del doble esc) |
| `i` | Volver a modo Terminal para escribir |
| `gf` | Abrir el archivo bajo el cursor. Sirve en stack traces |
| `<C-\><C-n>` | La salida que siempre funciona, incluso en `:terminal` |

**Los dos modos son todo el truco.** Un buffer de terminal arranca en *modo
Terminal*, donde cada tecla va al shell. Por eso no podías salir. El doble `esc`
te pasa a *modo Normal*, donde el buffer se comporta como cualquier archivo:
`j`/`k` scrollean, `y` copia, `/` busca. `i` te devuelve adentro.

**Por qué no `<C-/>`.** Es el default de LazyVim y sigue mapeado, pero en el
layout latam `/` es Shift+7, así que `Ctrl+/` es en realidad Ctrl+Shift+7 y la
terminal nunca manda el byte `^_` que nvim espera. `<M-t>` es un alias al mismo
toggle.

**Preferí esto antes que `:terminal`.** El `:terminal` pelado abre un buffer sin
ninguno de estos atajos: no hay `q`, no hay `gf`, no hay toggle. El doble `esc`
sí funciona ahí, pero el resto no existe.

## Código (LSP)

| Tecla | Acción |
|---|---|
| `gd` | Ir a la definición |
| `gr` | Buscar referencias |
| `gI` | Ir a la implementación |
| `gy` | Ir a la definición del tipo |
| `K` | Documentación del símbolo bajo el cursor |
| `gK` | Ayuda de firma |
| `<leader>ca` | Code action / quick fix |
| `<leader>cr` | Renombrar el símbolo en todos lados |
| `<leader>cR` | Renombrar el archivo y arreglar todos los imports |
| `<leader>co` | Ordenar imports |
| `<leader>cM` | Agregar todos los imports faltantes |
| `<leader>cf` | Formatear el buffer ahora |
| `<leader>ss` | Saltar a un símbolo de este archivo |
| `<leader>cl` | Qué servidores LSP están adjuntos acá |
| `]f` / `[f` | Función siguiente / anterior |
| `]c` / `[c` | Clase siguiente / anterior |
| `]]` / `[[` | Referencia siguiente / anterior de este símbolo |

## Errores y warnings

| Tecla | Acción |
|---|---|
| `]d` / `[d` | Diagnóstico siguiente / anterior |
| `]e` / `[e` | Solo errores |
| `]w` / `[w` | Solo warnings |
| `<leader>cd` | Ver el diagnóstico de esta línea completo |
| `<leader>xx` | Todos los diagnósticos del proyecto (Trouble) |
| `<leader>xX` | Solo los de este buffer |
| `<leader>cD` | Pedirle al LSP que arregle todo lo que pueda |
| `<leader>xt` | Todos los TODO / FIXME del proyecto |

## Git

| Tecla | Acción |
|---|---|
| `<leader>gg` | Abrir lazygit: stage, commit, branch, todo |
| `]h` / `[h` | Hunk modificado siguiente / anterior |
| `<leader>ghp` | Preview del hunk inline |
| `<leader>ghs` | Stage del hunk bajo el cursor |
| `<leader>ghr` | Descartar el hunk bajo el cursor |
| `<leader>ghb` | Blame de esta línea (popup de gitsigns) |
| `<leader>ghd` | Diff de este archivo contra HEAD |
| `<leader>gs` | Picker de git status |
| `<leader>gl` | Git log |
| `<leader>gf` | Historial del archivo actual |
| `<leader>gb` | Toggle de blame inline permanente, al final de cada línea (git-blame.nvim) |
| `<leader>gu` | Abrir la URL del commit de la línea actual (git-blame.nvim) |

**`<leader>ghb` vs `<leader>gb`.** Son dos plugins distintos. `ghb` (gitsigns)
muestra el blame de la línea actual en un popup, bajo demanda. `gb`
(git-blame.nvim) togglea un blame permanente pegado al final de cada línea, y
arranca apagado (`enabled = false`).

## Copilot y autocompletado

Copilot y el menú del LSP son **dos cosas separadas** a propósito.

### Copilot (ghost text en gris)

| Tecla | Acción |
|---|---|
| `<M-l>` | Aceptar la sugerencia |
| `<M-}>` / `<M-{>` | Sugerencia siguiente / anterior |
| `<M-c>` | Descartar la sugerencia |
| `<leader>aa` | CopilotChat en ventana flotante |
| `<leader>ae` | CopilotChat: explicar el código seleccionado |

Las llaves y no los corchetes: en latam las llaves no piden Shift. El chat vive
en `<leader>a` porque `<leader>c` es el grupo *code* de LazyVim.

### Menú de completado (blink)

El menú **se abre solo** mientras escribís. Estas teclas son para manejarlo.

| Tecla | Acción |
|---|---|
| `<C-n>` | Abrirlo si está cerrado, bajar un ítem si está abierto |
| `<C-p>` | Subir un ítem |
| `<CR>` | Aceptar |
| `<C-y>` | Aceptar el seleccionado |
| `<C-e>` | **Cerrar el menú** |
| `<Tab>` / `<S-Tab>` | Navegar el snippet |
| `<C-b>` / `<C-f>` | Scroll de la documentación |
| `<C-k>` | Ver la firma de la función |

El default de blink para abrirlo a mano es `<C-space>`, pero ese es el prefix de
herdr y nunca llega a nvim. Por eso vive en `<C-n>`, que además es la tecla
nativa de vim para completar. Por la misma razón la selección incremental de
treesitter se movió a `<M-e>`.

## Ventanas y splits

| Tecla | Acción |
|---|---|
| `<leader>\|` | Split vertical (lado a lado) |
| `<leader>-` | Split horizontal (uno arriba del otro) |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Mover el foco izquierda / abajo / arriba / derecha |
| `<C-↑>` `<C-↓>` `<C-←>` `<C-→>` | Redimensionar la ventana enfocada |
| `<leader>wd` | Cerrar esta ventana |
| `<C-w>` | Hydra de ventanas: mantenelo y seguí apretando |

**Tres teclas alt están en disputa.** nvim usa `<M-j>` / `<M-k>` para mover una
línea y `<M-l>` para aceptar la sugerencia de Copilot. herdr usa esos mismos
`alt+j` / `alt+k` / `alt+l` para moverse entre panes. Con un solo pane parecen
funcionar. Antes de confiar en ellas, split con `alt+v` y volvé a probar. herdr
también responde en `prefix+h/j/k/l`.

**Splits vs panes de herdr.** Estos parten *adentro* de nvim y comparten su LSP
y sus buffers. El `alt+v` de herdr parte la terminal misma. Misma idea, distinto
nivel: splits de nvim para código, panes de herdr para programas separados.

## Sesión y varios

| Tecla | Acción |
|---|---|
| `<leader>qs` | Restaurar la sesión de este directorio |
| `<leader>ql` | Restaurar la última sesión, cualquiera que sea |
| `<leader>.` | Toggle de un scratch buffer para notas descartables |
| `<leader>?` | Todas las teclas activas en este buffer |
| `<leader>sk` | Buscar entre todos los keymaps |
| `<leader>l` | Lazy: administrador de plugins |
| `<leader>cm` | Mason: instalador de LSP / formatters / linters |
| `<leader>uf` | Toggle del formateo al guardar |
| `<leader>uC` | Previsualizar colorschemes en vivo |
| `<leader>md` | Markdown: abrir el diagrama mermaid bajo el cursor en una pestaña nueva |
| `:checkhealth` | Diagnosticar qué está roto |

**Los diagramas mermaid se dibujan solos** al entrar al buffer y al salir de
insert, no mientras escribís. Si uno largo empuja a los demás fuera de la
pantalla y no aparecen, `<leader>md` lo abre suelto.

## Trampas que conviene saber

| Tecla | Trampa |
|---|---|
| `Ctrl+Z` | Suspende nvim al fondo. `fg` lo trae de vuelta. **No es deshacer** |
| `s` | Acá es Flash, no substitute. Para el comportamiento viejo usá `cl` |
| `:w` | Corre el formateador. Un archivo intacto puede terminar con diff |
| `<leader>e` | Togglea: desde un archivo te cierra el árbol. Usá `<C-h>` para enfocarlo |
| `}` solo | Salta a la próxima línea VACÍA, no al próximo bloque. Dos líneas en blanco seguidas piden dos toques |
| `<C-i>` | Es el mismo byte que Tab: remapear uno remapea el otro |
| `E139` | El archivo ya está en otro buffer, quizás oculto. `:ls!` para encontrarlo, `:bwipeout <n>` para liberarlo |
| `:w ruta` | En un buffer sin nombre guarda pero no lo bautiza. Usá `<leader>fs` |
| `esc` | Cuando estés perdido, apretalo dos veces. Después `u` para deshacer |

## Teclado latam

En este layout las llaves (`{` `}`) son los caracteres base y los corchetes
(`[` `]`) piden Shift. Por eso:

- Copilot cicla con `<M-}>` / `<M-{>` en vez de `<M-]>` / `<M-[>`.
- El terminal togglea con `<M-t>` en vez de `<C-/>`, porque `/` es Shift+7.

Los pares de navegación (`]d`, `[h`, `]q`) se quedan en corchetes, con Shift:
son convención de vim y es lo que vas a leer en cualquier documentación. Hubo
alias en llaves y se sacaron, porque una tecla no puede ser mapeo completo y
prefijo a la vez sin esperar `timeoutlen`.

Cuidado con un detalle del sistema: tenés `es` y `latam` como input sources, con
`es` primero. Los mapeos de arriba asumen latam. Si caés al grupo `es`, `{` pasa
a necesitar AltGr y se rompen.
