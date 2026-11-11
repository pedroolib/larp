---
name: larp
description: Edit a larp screen-recording session into a vertical Reel and a voice-over script for CapCut. With "linkedin", join several sessions into a horizontal LinkedIn video and post. Use when the user runs /larp or asks to edit work clips, make a reel, or write a LinkedIn post from sessions.
---

# larp

Sessions live in `~/Videos/larp/<YYYY-MM-DD_HHMM>/`. Each has `started`, `stopped`, `clips.tsv` (save time, requested seconds, file) and `clips/`. The tools are on PATH: `larp-sessions`, `larp-video`. Speak Spanish with the user.

The user finishes the video in CapCut online: voice (CapCut TTS), subtitles and music. So the video you render has no text, no audio and no music. Never upload or post anything.

## /larp [session_dir]

If there is no argument, use the newest folder in `~/Videos/larp/` that has `stopped`.

1. Context. Run `larp-sessions list <session>`. Show the conversations found (title, folder). Ask with AskUserQuestion (multiSelect) which ones belong to this work, plus "none". Then ask for one optional sentence about what they did. For each chosen conversation, run `larp-sessions text <session> <file>` and read it. If its `cwd` is a git repo, also run `git log --since=<started> --oneline` there.
2. Base video. Run `larp-video base <session>`. It drops overlapping parts between clips and still frames. It writes `base.mp4` and `base.json` (which base time came from which clip).
3. Look. Run `larp-video frames <session>/base.mp4` and Read the JPGs. If there are more than 60, read every other one. Note what is on screen at each time.
4. Privacy pass. Look for secrets on screen: passwords, API keys, tokens, private chats, email inboxes. If a frame shows one, leave that time range out of the edit. Tell the user what you cut and why.
5. Edit. Target 20 to 45 s total. Keep the moments that show progress, for example code running, a result appearing, hardware moving, or a UI change. Cut repetition. Keep chronological order. Write `<session>/reel.edl.json`:
   ```json
   {"out": "reel.mp4", "format": "vertical",
    "segments": [{"src": "base.mp4", "start": 3.0, "end": 9.5}]}
   ```
   Framing: by default leave out `crop`. The full screen then sits in the middle over a blurred copy. If all the action of a segment stays in one area (one terminal or window), add `"crop": [x, y, w, h]` to zoom in. The values are pixels of the source video, at the size that `frames` printed. A tall crop (near 9:16) fills the phone screen best.
6. Render: `larp-video render <session>/reel.edl.json`. Then run `larp-video frames <session>/reel.mp4 2` and look at a few frames. If the framing is wrong, fix the EDL and render again.
7. Write `<session>/guion.md`:
   - Voice-over script in English, then in Spanish. Use blocks with times of the final reel, for example `0:00–0:06 Today I wired the IMU to the ESP32.` Use about 2.5 words per second, so the text fits the block. First person, casual, no hype words. The first block is the hook (what you are building). The last block is what is next.
   - Instagram caption in English and in Spanish, 1 to 3 short lines each, then 5 to 8 hashtags.
8. Write `<session>/resumen.md`: date, project(s), what was done, what is next, in 3 to 6 short lines. `/larp linkedin` reads it later.
9. Tell the user the paths of `reel.mp4` and `guion.md`, the final length, and anything you cut for privacy.

## /larp linkedin

1. List folders in `~/Videos/larp/` that have `resumen.md`, newest first, with the first line of each. Ask with AskUserQuestion (multiSelect) which sessions go into the post.
2. Read their `resumen.md`. Write `~/Videos/larp/linkedin-<YYYY-MM-DD>/post.md`. The post is in English, 80 to 200 words, first person. Be concrete: what was built, one problem solved, what is next. End with 3 to 5 hashtags. No hype words and no emoji walls.
3. Video. For each chosen session, look at the frames of its `base.mp4`. If the `frames-base/` folder is missing, run `larp-video frames` first. Pick the best 5 to 15 s of each session. Write `linkedin.edl.json` in the linkedin folder with `"format": "landscape"` and `"out": "linkedin.mp4"`. Make `src` paths relative to that folder, for example `../2026-11-11_0930/base.mp4`. Target 30 to 90 s total. Render with `larp-video render`.
4. Write `guion.md` there: voice-over script in English and Spanish with times, same rules as above.
5. Tell the user the paths of `post.md`, `linkedin.mp4` and `guion.md`.
