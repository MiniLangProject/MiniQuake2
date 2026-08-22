# Cinematic Product Acceptance

MiniQuake2 exposes the existing Quake II CIN decoder, 14-fps player, palette
handoff and append-only PCM mixer through the product executable:

```powershell
.\build\MiniQuake2.exe --cinematic "C:\Games\Quake2" idlog 0 0
```

The name accepts `idlog`, `idlog.cin`, or `video/idlog.cin`. `FRAMES=0` plays
to completion; `LOOP=1` repeats until the window is closed. Escape opens the
normal menu and pauses both the cinematic clock and its mixer channel; closing
the menu resumes without advancing the stream. Completion or window close
stops PCM, restores the game palette, shuts down the audio device and destroys
the OpenGL window.

Classic `+nextserver` chains are also executable through `--media-sequence`;
see [`MEDIA_SEQUENCE_ACCEPTANCE.md`](MEDIA_SEQUENCE_ACCEPTANCE.md).

## Retail evidence

The installed, user-owned fixture is read in place and never copied:

| Path | Bytes | SHA-256 |
|---|---:|---|
| `baseq2/video/idlog.cin` | 3,159,828 | `D5177F538BE17641EF97D5D0D9CB5DEB80954447D430789858ACC32C1C6C0C43` |

A complete native product run passed with:

- 368 rendered window frames;
- final CIN stream frame 81 and exactly one completion;
- zero dropped CIN frames;
- 254,976 stereo frames painted through an opened native audio device.

The first product attempt exposed a real compatibility defect: stock CIN files
contain unused Huffman context rows with zero symbols. Original
`Huff1TableInit` records leaf 255 for those rows, while MiniQuake2 previously
rejected them as malformed. The format decoder now mirrors the bounded classic
fallback; malformed command, size, palette, pixel, audio and clock boundaries
remain strict and covered by native tests.

## Remaining integration boundary

This command closes real retail decoding/render/audio/device lifecycle. The
product now parses and executes CIN/PCX/map `+nextserver` sequences, including
named map spawn points. The active `--play` loop consumes the validated queued
`gamemap` after intermission and enters that executor. One product window and
renderer now span the complete chain with loading frames between steps. Menu
`quit`, pause/resume and live mixer volume now
share the product command policy documented in
[`UI_AUDIO_ACCEPTANCE.md`](UI_AUDIO_ACCEPTANCE.md).
