# larp

Record clips of your work with a replay buffer, then let Claude cut them into a vertical Reel and write a voice-over script for CapCut.

## Install

Run the installer from the repo folder:

```bash
./install.sh
```

The installer links `bin/*` into `~/.local/bin` and links `skill/` to `~/.claude/skills/larp`. It also adds the menu rows from `omarchy/menu-rows.jsonc` to `~/.config/omarchy/extensions/omarchy-menu.jsonc` and binds `Super+Shift+R` in `~/.config/hypr/bindings.lua`. It makes a backup of each file before the first change. You can run it again safely.

## Use

1. Press `Super+Shift+R` and pick Start Recording. The screen of the focused monitor goes into a 5 min buffer on disk. There is no audio.
2. When something worth showing happens, press `Super+Shift+R` and pick Clip 30s, Clip 1 min or Clip 5 min.
3. When you finish, pick Stop Recording. If the session has clips, a terminal opens with `claude "/larp <session>"`.
4. Claude asks which Claude Code conversations belong to the work, cuts the clips, and writes the files below.
5. Open `reel.mp4` in CapCut online. Add the voice (TTS) from `guion.md`, the subtitles and the music.

For a LinkedIn post that joins several sessions, run `/larp linkedin` in Claude Code.

## Files

Each session is a folder `~/Videos/larp/<YYYY-MM-DD_HHMM>/`:

| File | Content |
|---|---|
| `clips/`, `clips.tsv` | Raw clips and the save time of each one. Nothing deletes them. |
| `base.mp4`, `base.json` | Clips joined, without overlaps and still frames. |
| `reel.mp4` | 1080x1920 cut, no text, no audio. |
| `guion.md` | Voice-over script with times, in English and Spanish, plus the Instagram caption. |
| `resumen.md` | Short summary that `/larp linkedin` reads. |

## Commands

```
larp start | clip <seconds> | stop | status | menu
larp-sessions list <session> | text <session> <jsonl>
larp-video base <session> | frames <video> [every_s] | render <edl.json> | selftest
```

Set `LARP_DIR` to keep sessions somewhere other than `~/Videos/larp`.

## Limits

The screen can show passwords, API keys or private code. Claude leaves out frames that look like secrets, but it can miss some. You must watch the video before you post it.
