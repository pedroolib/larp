# larp: plan de la versión 1

Sistema para grabar clips de tu trabajo y convertirlos en un Reel vertical y en un post de LinkedIn. Claude hace los cortes y el guion. Tú pones la voz, los subtítulos y la música en CapCut online. Nada se publica en automático.

## Herramientas que ya están instaladas

- `gpu-screen-recorder` 6.1.4 y `gsr-cli`, para el replay buffer (memoria que guarda solo los últimos N segundos).
- `ffmpeg`, para cortar, unir y acomodar el video.
- El menú de Omarchy, que se extiende con JSONC en `~/.config/omarchy/extensions/omarchy-menu.jsonc`.

## Grabación

1. Un atajo de Hyprland (`Super+Shift+R`) corre `omarchy menu summon larp`.
2. Sin sesión, el menú muestra "Start Recording". El campo `when` oculta las demás filas.
3. Start lanza `gpu-screen-recorder` con `-r 300 -replay-storage disk -ipc <socket>`. Graba solo pantalla, sin micrófono.
4. Con sesión, el menú muestra Clip 30s, Clip 1 min, Clip 5 min y Stop Recording.
5. Cada clip usa `gsr-cli save-replay <segundos>` y se guarda en `~/Videos/larp/<fecha-hora>/`. Cada acción muestra una notificación.
6. Si paras sin clips, solo se para la grabación.
7. Si paras con clips, se abre una terminal con `claude "/larp <sesión>"`.
8. Si `gpu-screen-recorder` se cae, sale una notificación de error y el menú vuelve a "Start".

## Skill `/larp <sesión>`

1. La skill busca los `.jsonl` de `~/.claude/projects/` que cambiaron entre el inicio y el fin de la sesión.
2. La skill te muestra la lista. Tú eliges cuáles cuentan y escribes una frase de contexto opcional.
3. `ffmpeg` quita las partes donde la pantalla no cambia (`mpdecimate`).
4. La skill une los clips y quita las partes repetidas cuando dos clips se enciman.
5. Claude mira un cuadro cada 3 s más o menos para elegir los cortes y el encuadre.
6. La skill hace `reel.mp4` de 1080x1920, sin texto ni música.
7. La skill escribe `guion.md` y `resumen.md`.

El encuadre vertical por defecto pone el video horizontal en medio, con fondo difuminado arriba y abajo. Claude usa zoom solo cuando toda la acción de un tramo pasa en una misma zona.

## Skill `/larp linkedin`

1. Tú eliges las sesiones que entran en el post.
2. La skill lee sus `resumen.md` y escribe el post en inglés.
3. La skill arma `linkedin.mp4` de 1920x1080 con los clips de esas sesiones, sin texto.
4. La skill escribe un guion de voz con tiempos, en inglés y en español, para CapCut.

## Carpeta de cada sesión

| Archivo | Contenido |
|---|---|
| `clips/` | Clips crudos. No se borran solos. |
| `reel.mp4` | Video vertical para editar en CapCut. |
| `guion.md` | Bloques con tiempo (unas 2.5 palabras por segundo) en inglés y en español, más el caption de Instagram con hashtags en los dos idiomas. |
| `resumen.md` | Lo que se hizo en la sesión. Lo usa `/larp linkedin`. |

## Dónde vive el código

Repo nuevo `~/Projects/larp` con el script de grabación, la extensión del menú y la skill. La skill se enlaza en `~/.claude/skills/larp`.

## Fuera de la versión 1

- Micrófono y transcripción.
- Voz TTS automática. La voz se hace en CapCut.
- Subida automática a Drive, Instagram o LinkedIn.
- Limpieza automática de clips viejos.
- Revisión automática de secretos en pantalla.

## Riesgo abierto

La pantalla puede mostrar contraseñas, llaves de API o código privado. En la versión 1, la única defensa es que tú revises el video antes de publicarlo.
