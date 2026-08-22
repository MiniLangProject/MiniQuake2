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
- DM2 is recognized but fails explicitly because demo playback is not yet
  implemented.

## Retail evidence

Two installed-data product chains pass without copying assets:

| Sequence | Result |
|---|---|
| `eou1_.cin+*bunk1$start` | CIN frame presentation, `bunk1` load, named `start` spawn and one rendered game frame |
| `end.cin+victory.pcx` | one CIN step plus the decoded/paletted terminal picture; two steps completed |

Both steps report `host-generation=1 loading-frames=2`: the same native window
and initialized Renderer API instance survives the entire chain. A loading
plaque is presented before each potentially allocating/decoding step.

Asset-free native gates cover the complete grammar, malformed cases, the PCX
palette lifecycle and explicit named-spawn propagation. Existing listen,
map-change, campaign-goal, dedicated, deathmatch and cooperative session tests
remain green.

## Remaining boundary

The command closes parsing and product execution of classic media chains. The
active `--play` loop also validates and atomically consumes the game module's
queued `gamemap` command after intermission, shuts the old session down and
enters the same executor. Map, CIN and PCX steps now share one product host and
loading lifecycle; map render resources are released between steps while the
window/GL context remains owned until the complete chain ends. DM2 playback is
the remaining classic media type and is still rejected explicitly.
