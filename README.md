# MiniQuake2

[![License: GPL-2.0-or-later](https://img.shields.io/badge/License-GPL--2.0--or--later-blue.svg)](LICENSE.md)
[![Language: MiniLang](https://img.shields.io/badge/written%20in-MiniLang-5b5bd6.svg)](.)

MiniQuake2 is an unofficial Windows x64 port of the original Quake II 3.19
engine and `baseq2` game to
[MiniLang](https://github.com/MiniLangProject). The project aims to preserve
Quake II's gameplay, data formats, Game API v3 semantics and Protocol 34 while
providing a modern, self-contained desktop build.

> [!IMPORTANT]
> MiniQuake2 does not include Quake II game data. You must own and supply a
> legal installation containing `baseq2/pak0.pak`.

## Screenshots

| Outer Base (`base1`) | Receiving Center (`fact3`) |
| --- | --- |
| [![MiniQuake2 running base1](docs/screenshots/levels/base1.jpg)](docs/screenshots/levels/base1.jpg) | [![MiniQuake2 running fact3](docs/screenshots/levels/fact3.jpg)](docs/screenshots/levels/fact3.jpg) |

### Complete campaign gallery

The gallery covers all 39 single-player BSPs in MiniQuake2's canonical
campaign matrix. Every image is a full 1920x1080 product frame captured at the
authored level start after the view weapon has settled. The captures exercise
the live server, Game API, snapshot, client, renderer and HUD path and contain
no missing assets. JPEG previews are progressive and open at full resolution.

<details>
<summary><strong>Quake II — 39 campaign maps</strong></summary>

| | | |
| --- | --- | --- |
| **BASE1**<br>[![BASE1](docs/screenshots/levels/base1.jpg)](docs/screenshots/levels/base1.jpg) | **BASE2**<br>[![BASE2](docs/screenshots/levels/base2.jpg)](docs/screenshots/levels/base2.jpg) | **BASE3**<br>[![BASE3](docs/screenshots/levels/base3.jpg)](docs/screenshots/levels/base3.jpg) |
| **BIGGUN**<br>[![BIGGUN](docs/screenshots/levels/biggun.jpg)](docs/screenshots/levels/biggun.jpg) | **BOSS1**<br>[![BOSS1](docs/screenshots/levels/boss1.jpg)](docs/screenshots/levels/boss1.jpg) | **BOSS2**<br>[![BOSS2](docs/screenshots/levels/boss2.jpg)](docs/screenshots/levels/boss2.jpg) |
| **BUNK1**<br>[![BUNK1](docs/screenshots/levels/bunk1.jpg)](docs/screenshots/levels/bunk1.jpg) | **CITY1**<br>[![CITY1](docs/screenshots/levels/city1.jpg)](docs/screenshots/levels/city1.jpg) | **CITY2**<br>[![CITY2](docs/screenshots/levels/city2.jpg)](docs/screenshots/levels/city2.jpg) |
| **CITY3**<br>[![CITY3](docs/screenshots/levels/city3.jpg)](docs/screenshots/levels/city3.jpg) | **COMMAND**<br>[![COMMAND](docs/screenshots/levels/command.jpg)](docs/screenshots/levels/command.jpg) | **COOL1**<br>[![COOL1](docs/screenshots/levels/cool1.jpg)](docs/screenshots/levels/cool1.jpg) |
| **FACT1**<br>[![FACT1](docs/screenshots/levels/fact1.jpg)](docs/screenshots/levels/fact1.jpg) | **FACT2**<br>[![FACT2](docs/screenshots/levels/fact2.jpg)](docs/screenshots/levels/fact2.jpg) | **FACT3**<br>[![FACT3](docs/screenshots/levels/fact3.jpg)](docs/screenshots/levels/fact3.jpg) |
| **HANGAR1**<br>[![HANGAR1](docs/screenshots/levels/hangar1.jpg)](docs/screenshots/levels/hangar1.jpg) | **HANGAR2**<br>[![HANGAR2](docs/screenshots/levels/hangar2.jpg)](docs/screenshots/levels/hangar2.jpg) | **JAIL1**<br>[![JAIL1](docs/screenshots/levels/jail1.jpg)](docs/screenshots/levels/jail1.jpg) |
| **JAIL2**<br>[![JAIL2](docs/screenshots/levels/jail2.jpg)](docs/screenshots/levels/jail2.jpg) | **JAIL3**<br>[![JAIL3](docs/screenshots/levels/jail3.jpg)](docs/screenshots/levels/jail3.jpg) | **JAIL4**<br>[![JAIL4](docs/screenshots/levels/jail4.jpg)](docs/screenshots/levels/jail4.jpg) |
| **JAIL5**<br>[![JAIL5](docs/screenshots/levels/jail5.jpg)](docs/screenshots/levels/jail5.jpg) | **LAB**<br>[![LAB](docs/screenshots/levels/lab.jpg)](docs/screenshots/levels/lab.jpg) | **MINE1**<br>[![MINE1](docs/screenshots/levels/mine1.jpg)](docs/screenshots/levels/mine1.jpg) |
| **MINE2**<br>[![MINE2](docs/screenshots/levels/mine2.jpg)](docs/screenshots/levels/mine2.jpg) | **MINE3**<br>[![MINE3](docs/screenshots/levels/mine3.jpg)](docs/screenshots/levels/mine3.jpg) | **MINE4**<br>[![MINE4](docs/screenshots/levels/mine4.jpg)](docs/screenshots/levels/mine4.jpg) |
| **MINTRO**<br>[![MINTRO](docs/screenshots/levels/mintro.jpg)](docs/screenshots/levels/mintro.jpg) | **POWER1**<br>[![POWER1](docs/screenshots/levels/power1.jpg)](docs/screenshots/levels/power1.jpg) | **POWER2**<br>[![POWER2](docs/screenshots/levels/power2.jpg)](docs/screenshots/levels/power2.jpg) |
| **SECURITY**<br>[![SECURITY](docs/screenshots/levels/security.jpg)](docs/screenshots/levels/security.jpg) | **SPACE**<br>[![SPACE](docs/screenshots/levels/space.jpg)](docs/screenshots/levels/space.jpg) | **STRIKE**<br>[![STRIKE](docs/screenshots/levels/strike.jpg)](docs/screenshots/levels/strike.jpg) |
| **TRAIN**<br>[![TRAIN](docs/screenshots/levels/train.jpg)](docs/screenshots/levels/train.jpg) | **WARE1**<br>[![WARE1](docs/screenshots/levels/ware1.jpg)](docs/screenshots/levels/ware1.jpg) | **WARE2**<br>[![WARE2](docs/screenshots/levels/ware2.jpg)](docs/screenshots/levels/ware2.jpg) |
| **WASTE1**<br>[![WASTE1](docs/screenshots/levels/waste1.jpg)](docs/screenshots/levels/waste1.jpg) | **WASTE2**<br>[![WASTE2](docs/screenshots/levels/waste2.jpg)](docs/screenshots/levels/waste2.jpg) | **WASTE3**<br>[![WASTE3](docs/screenshots/levels/waste3.jpg)](docs/screenshots/levels/waste3.jpg) |

</details>

## Highlights

- Engine, client, server, renderer front end and `baseq2` game logic written in
  MiniLang.
- Original PAK, BSP38, MD2, SP2, WAL, PCX, CIN, WAV, DM2 and private-save
  format support.
- Single-player campaign, cooperative play, deathmatch, save/load, inventory,
  weapons, movers, monsters, cinematics, demos and attract mode.
- Protocol 34 networking with prediction, downloads, listen servers and
  dedicated servers.
- Classic lightmaps, sky, warp, flowing and translucent surfaces, inline brush
  models, MD2 interpolation, view weapons, particles and shadows.
- Native Windows x64 window, raw input, controller, UDP, PCM audio and OpenGL
  bridges behind MiniLang-owned runtime state.
- Resolution-aware menus and HUD, windowed/fullscreen modes through 4K, mouse
  inversion, rebinding and persistent `miniquake2.cfg` settings.
- OGG music discovery for classic and Steam rerelease layouts, plus original
  CIN and DM2 playback timing.

## Project status

MiniQuake2 is playable and under active development. Its automated suite covers
all 39 campaign maps, the stock spawn table, Game API behavior, networking,
rendering, audio, persistence and long-running sessions. This is strong
compatibility evidence, not a claim that every encounter, rendered pixel or
hardware configuration is already identical to Quake II 3.19.

The concise maintained overview is the
[parity audit](docs/PARITY_AUDIT.md). Detailed source comparisons and acceptance
evidence remain available under [`docs`](docs/), while known limitations are
tracked in [`BLOCK_LEDGER.json`](BLOCK_LEDGER.json).

## Quick start

Build MiniQuake2, then point it at the directory containing `baseq2`:

```powershell
$Quake2Base = "C:\Program Files (x86)\Steam\steamapps\common\Quake 2"
& .\build\MiniQuake2.exe --data-root $Quake2Base
```

`--data-root` validates and remembers the installation, then opens the main
menu. Later launches need no arguments:

```powershell
& .\build\MiniQuake2.exe
```

Start a map directly when required:

```powershell
& .\build\MiniQuake2.exe --play $Quake2Base base1 0
```

The final `0` keeps the interactive session open until the window is closed.

Unhandled runtime errors leave fullscreen and mouse capture before opening a
topmost crash dialog. The complete report is copied to the Windows clipboard
and written to `miniquake2-crash.log`; if the clipboard is temporarily busy,
focus the dialog and press `Ctrl+C` to copy its contents.

## Building

Requirements:

- Windows x64 and PowerShell.
- Python 3.
- The Python MiniLang compiler and standard library. A sibling checkout named
  `MiniLangCompilerPy` is detected automatically.
- A legal Quake II installation is required only for retail validation and
  playing, never for the asset-free build and unit suite.

From the repository root:

```powershell
.\build.ps1
```

The native Windows, OpenGL, audio, input, Ogg Vorbis and text bridges are fully
source-owned by this repository. A normal build rebuilds both bridges before
compiling MiniLang so the checked product cannot drift from the C sources:

```powershell
.\build.ps1
```

For a local MiniLang-only iteration, `-SkipNativeRebuild` explicitly reuses the
checked-in bridge DLLs; release and verification builds must not use it.

Explicit compiler locations can be supplied when the repositories are not
siblings:

```powershell
.\build.ps1 `
  -Compiler C:\path\to\MiniLangCompilerPy\mlc_win64.py `
  -StdLib C:\path\to\MiniLangCompilerPy
```

The release executable is written to `build/MiniQuake2.exe`.

## Default controls

| Action | Default input |
| --- | --- |
| Move | `W`, `A`, `S`, `D` |
| Look | Mouse |
| Attack | Left mouse button |
| Jump | `Space` |
| Crouch | `C` |
| Run | `Shift` |
| Use | `E` |
| Inventory | `I` |
| Previous/next weapon | Mouse wheel |
| Select weapon | `0` through `9` |
| Main menu | `Esc` |

Bindings, sensitivity, vertical-axis inversion, always-run, handedness,
controller input and display settings are available from the menus and persist
in `baseq2/miniquake2.cfg`.

## Media and display

The Video menu supports 640x480 through 3840x2160, windowed or fullscreen.
Unavailable exclusive modes fall back safely to a supported desktop mode.
Display changes rebuild the live window, OpenGL context and map resources
without discarding gameplay settings.

MiniQuake2 searches for OGG music below both classic `baseq2/music` and Steam
rerelease layouts. Stock cinematics and demos are read directly from the
user-owned PAK files and follow their original timing and next-server chains.

## Tests and verification

The complete source, build and compiled MiniLang test suite has one entry
point:

```powershell
.\scripts\test.ps1
```

Useful retail gates include:

```powershell
.\scripts\campaign_smoke.ps1 -Quake2Root $Quake2Base
.\scripts\physical_campaign_smoke.ps1 -Quake2Root $Quake2Base
.\scripts\session_soak.ps1 -Quake2Root $Quake2Base -Frames 100000
.\scripts\hardware_acceptance.ps1 -Quake2Root $Quake2Base
```

Rebuild the complete README gallery from authored gameplay starts with:

```powershell
.\scripts\capture_level_gallery.ps1 -Quake2Root $Quake2Base
```

The capture workflow never extracts or copies proprietary retail assets; only
rendered JPEG screenshots are written to `docs/screenshots/levels`.

## Repository layout

| Path | Purpose |
| --- | --- |
| `src/` | MiniLang engine, client, server, game, renderer and platform logic |
| `native/` | Narrow prebuilt Windows x64 runtime bridges |
| `tests/` | Deterministic unit, integration, protocol and retail test programs |
| `tools/` | Verification, capture, comparison and evidence utilities |
| `scripts/` | Build, packaging and retail-acceptance workflows |
| `docs/` | Architecture, parity and release evidence plus screenshots |

## Documentation

- [Compatibility and asset contract](docs/COMPATIBILITY_CONTRACT.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Current parity audit](docs/PARITY_AUDIT.md)
- [Detailed original-source audit](docs/ORIGINAL_PARITY_AUDIT_2026-08-26.md)
- [Playability matrix](docs/PLAYABILITY_MATRIX.md)
- [Release acceptance](docs/RELEASE_ACCEPTANCE.md)
- [Retail FPS report](docs/ALL_LEVEL_FPS_2026-08-26.md)

## Legal and licensing

MiniQuake2 is an independent project and is not affiliated with or endorsed by
id Software, Bethesda Softworks or ZeniMax Media. Quake II names and game
assets remain the property of their respective owners. Do not commit or
redistribute proprietary PAK files, maps, textures, music, cinematics or other
retail data with this repository.

Quake II-derived work is distributed under GPL-2.0-or-later. Independently
authored build and verification tooling may use Apache-2.0. See
[`LICENSE.md`](LICENSE.md), [`NOTICE.md`](NOTICE.md) and each file's SPDX
identifier for the applicable terms and retained notices.
