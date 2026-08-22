# Campaign Media Sequence Acceptance

MiniQuake2 implements the original `SV_Map` level-string grammar:

```text
[*]<map-or-media>[$spawnpoint][+nextserver]
```

Every `+` component is parsed before execution, bounded to 16 steps and
classified as map, CIN, PCX or DM2. Empty components, traversal, path
separators, duplicate `$`, media spawn points and media end-of-unit markers
are rejected before any asset or session is opened.

The product command executes the resulting chain in order:

```powershell
.\build\MiniQuake2.exe --media-sequence "C:\Games\Quake2" `
  "eou1_.cin+*bunk1$start" 0
```

- CIN uses the retail Huffman/palette/PCM/device player;
- PCX uses the same palette and `DrawStretchRaw` renderer contract, waiting
  for Space/Enter when `FRAMES=0`;
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
| `eou1_.cin+*bunk1$start` | CIN frame presentation, `bunk1` load, named `start` spawn and one rendered game frame |
| `end.cin+victory.pcx` | one CIN step plus the decoded/paletted terminal picture; two steps completed |
| `demo1.dm2` | 696 packets, 688 rendered frames, `base2`, status `completed` |
| `demo1.dm2+base1` | one rendered demo frame followed by one live PlaySession frame in the same window/GL context |

The CIN/PCX pair reports `host-generation=1 loading-frames=2`: one initialized
Renderer API instance survives the chain. The heavyweight DM2/map pair reports
generation 2 and two loading frames: it preserves the native window and OpenGL
context while rebuilding only renderer-owned managed state between expanded
BSPs. This bounded lifecycle prevents the first map/MD2/WAV graph from leaking
into the second step.

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
