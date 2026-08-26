# Media and Startup Audit — 2026-08-26

This audit compares the Quake II 3.19 startup/media rules, the installed
retail configuration and the MiniQuake2 Release product. Retail files are read
in place and are neither copied nor modified.

## Startup and New Game

With no late command on the command line, Quake II executes the retail `d1`
alias. MiniQuake2 now does the same:

```text
idlog.cin -> demo1.dm2 -> idlog.cin -> demo2.dm2 -> repeat
```

This is the original attract loop, not a synthetic replacement. A key press
interrupts CIN, PCX or DM2 playback and opens the normal menu. Losing focus or
opening the menu pauses the media clock and audio instead of letting playback
run ahead. An explicit command such as `--play`, `--demo` or `--cinematic`
continues to bypass the automatic attract loop.

The retail New Game command is `map *ntro.cin+base1`. MiniQuake2 preserves the
leading end-of-unit marker and runs the same intro-to-map sequence:

```text
*ntro.cin -> base1
```

## Deterministic retail audit

```powershell
.\build\MiniQuake2.exe --media-audit "C:\Games\Quake2"
```

The final run passed with:

- exact startup and New Game sequences;
- `idlog.cin` and `ntro.cin` at 320x240, 22,050 Hz, with first audio block of
  1,575 frames;
- `demo1.dm2`: 696 packets, 688 rendered frames, `base2`, CD track 7;
- `demo2.dm2`: 625 packets, 617 rendered frames, `waste2`, CD track 7;
- `base1`: CD track 9, resolved to the installed replacement
  `rerelease/baseq2/music/track09.ogg`, 44,100-Hz stereo.

## Cinematics

The stock video inventory used by the campaign is:

| Video | Retail decode/render check |
|---|---|
| `idlog.cin` | complete playback; stream frame 81; native audio device active; 310 host frames; 269,312 mixed stereo frames; one scheduler drop |
| `ntro.cin` | real two-frame decode, palette upload, render and audio mix; zero drops |
| `end.cin` | real two-frame decode, palette upload, render and audio mix; zero drops |
| `eou1_.cin` through `eou8_.cin` | each passed real two-frame decode, palette upload, render and audio mix; zero drops |

The one full-`idlog` scheduler drop is within the documented hardware policy
of at most one. Playback still completed and audio remained active. The
deterministic preview path reported zero drops. CIN timing remains the original
14 fps; completion restores the game palette and releases the media audio
channel.

## Demos and music

Both installed release demos were also played to completion through the live
snapshot, effect, renderer and mixer path:

| Demo | Result |
|---|---|
| `demo1.dm2` | 688/688 rendered frames, 696 packets, 19,763 submitted entities, CD track 7, replacement OGG active |
| `demo2.dm2` | 617/617 rendered frames, 625 packets, 27,059 submitted entities, CD track 7, replacement OGG active |

The final missing-asset audit reports zero for `demo2`. `demo1` reports only
`weapons/v_shotg/flash2/tris.md2`: that path is referenced by the original
stock demo but is absent from every installed stock PAK, so it is a retail
fixture omission rather than a MiniQuake2 resolver or renderer defect. Normal
optional player-skin fallback is no longer counted as missing content.

Level music is driven by the worldspawn `sounds` field through `CS_CDTRACK`.
It starts and changes with maps and demos, pauses on focus/menu pause, and uses
the installed OGG replacement when present. The normal audio fallback remains
available when a replacement track is absent.

Related acceptance details are in
[`CINEMATIC_ACCEPTANCE.md`](CINEMATIC_ACCEPTANCE.md),
[`MEDIA_SEQUENCE_ACCEPTANCE.md`](MEDIA_SEQUENCE_ACCEPTANCE.md) and
[`UI_AUDIO_ACCEPTANCE.md`](UI_AUDIO_ACCEPTANCE.md).
