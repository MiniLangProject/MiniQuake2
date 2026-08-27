# Campaign Media Sequence Acceptance

MiniQuake2 implements the original `SV_Map` level-string grammar:

```text
[*]<map-or-media>[$spawnpoint][+nextserver]
```

Every `+` component is parsed before execution, bounded to 16 steps and
classified as map, CIN, PCX or DM2. Empty components, traversal, path
separators, duplicate `$` and media spawn points are rejected before any asset
or session is opened. Queued campaign handoffs are additionally bounded to 64
successive specifications and executed iteratively. A leading `*` is legal for
both maps and media and marks the end-of-unit transition used by stock New
Game.

The product command executes the resulting chain in order:

```powershell
.\build\MiniQuake2.exe --media-sequence "C:\Games\Quake2" `
  "eou1_.cin+*bunk1$start" 0
```

- CIN uses the retail Huffman/palette/PCM/device player;
- PCX uses the same palette and `DrawStretchRaw` renderer contract. With
  `FRAMES=0`, any gameplay key/controller input advances after the one-second
  accidental-skip guard; `nextserver` can advance it directly;
- map steps create the real UDP PlaySession and preserve `$spawnpoint` through
  `SpawnEntities` and `PutClientInServer`;
- `*` is retained as the end-of-unit property; a new sequence session already
  begins with reset cross-unit state;
- DM2 uses the strict length-framed DemoSession and the same transactional
  snapshot/effect/UI dispatcher as live Protocol 34. The installed release
  demos identify as Protocol 26; only this isolated replay path applies the
  original 3.19 compatibility rule (no frame suppress byte).

## Retail evidence

Two installed-data product chains pass without copying assets:

| Sequence | Result |
|---|---|
| `*ntro.cin+base1` | stock New Game intro followed by a fresh `base1` session at the selected skill |
| `eou1_.cin+*bunk1$start` | CIN frame presentation, `bunk1` load, named `start` spawn and one rendered game frame |
| `end.cin+victory.pcx` | one CIN step plus the decoded/paletted terminal picture; two steps completed |
| `demo1.dm2` | 696 packets, 688 rendered frames, `base2`, status `completed` |
| `demo1.dm2+base1` | one rendered demo frame followed by one live PlaySession frame in the same window/GL context |
| `base1 -> base2$base1` | authored changelevel, intermission command, old-session teardown and a fresh `base2` render session |

The CIN/PCX pair reports `host-generation=1 loading-frames=2`: one initialized
Renderer API instance survives the chain. The heavyweight DM2/map pair reports
generation 2 and two loading frames: it preserves the native window and OpenGL
context while rebuilding only renderer-owned managed state between expanded
BSPs. This bounded lifecycle prevents the first map/MD2/WAV graph from leaking
into the second step.

The focused installed-data gate is:

```powershell
.\build\MiniQuake2.exe --changelevel-smoke "C:\Games\Quake2" base1 base2 240
```

It drives the real `base1` `target_changelevel`, forces the normal intermission
exit, consumes `gamemap "base2$base1"`, and asserts that the returned product
result belongs to `base2`. The old implementation entered the media executor
recursively from the still-live `base1` function; the gate now proves that the
first map has returned before the successor BSP is expanded.

Asset-free native gates cover the complete grammar, malformed cases, the PCX
palette lifecycle and explicit named-spawn propagation. Existing listen,
map-change, campaign-goal, dedicated, deathmatch and cooperative session tests
remain green.

## Remaining boundary

The command closes parsing and product execution of classic media chains. The
active `--play` loop also validates and atomically consumes the game module's
queued `gamemap` command after intermission, shuts the old session down and
enters the same executor. Map, CIN, PCX and DM2 steps share one product host and
loading lifecycle; map render resources, resolver singletons and inactive PCM
channels are released between steps while the window/GL context remains owned
until the complete chain ends. Remaining demo work is paired original-process
timing/pixel evidence on a host where the installed executable runs, not a
missing playback path.
