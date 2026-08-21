# MiniQuake2 Architecture Decisions

## A01: MiniLang owns engine and gameplay behavior

The client, qcommon, collision model, server, Game API adapter, `baseq2` game
module, renderer front end, audio mixer, protocol implementation, and file
parsers belong in MiniLang. Native code may expose only capabilities that
require an operating-system, device, socket, or graphics-driver boundary.

Allowed native responsibilities include Win32 window/event integration,
monotonic time, file handles, UDP sockets, audio-device buffers, controller
enumeration, and OpenGL/Vulkan/D3D entry points. Native code must not decide
game rules, protocol state, collision results, renderer scene composition, or
entity behavior.

## A02: Game API v3 is an internal typed boundary

The semantic boundary from `game/game.h` remains intact, but it is represented
by MiniLang records containing first-class functions and explicit state
handles. The engine supplies the Game API imports; the `baseq2` module returns
the exports.

The v3 lifecycle is preserved:

```text
engine builds imports
  -> baseq2 GetGameApi equivalent
  -> validate apiversion == 3
  -> Init
  -> SpawnEntities / client calls / RunFrame
  -> WriteGame + WriteLevel or ReadGame + ReadLevel
  -> Shutdown
```

All v3 import categories remain represented: printing/errors, sound,
configstrings, resource indexes, collision/visibility, entity linking,
`Pmove`, message writing/multicast/unicast, tagged allocation, cvars, command
arguments, command injection, and debug graphing. All v3 export callbacks and
the edict-array metadata remain represented.

MiniLang values do not impersonate C pointers or raw structs. Edicts, clients,
models, images, cvars, and allocations use validated handles/references.
Varargs imports receive typed formatting adapters. Network and save adapters
perform field-by-field serialization.

Loading an original `gamex86.dll` is deferred. If later required, it will be a
separate native ABI adapter outside the internal API and must prove callback,
calling-convention, pointer-lifetime, and 32-bit-layout safety.

## A03: Renderer API v3 is an internal typed boundary

The renderer interface from `client/ref.h` remains an engine/renderer seam.
Its MiniLang export record covers registration, resource lookup, sky setup,
frame rendering, 2D drawing, raw cinematic drawing, palette changes, frame
begin/end, and application activation. The import record covers errors,
commands, console output, filesystem access, cvars, and video-mode services.

The initial renderer is the reference OpenGL behavior. The renderer consumes
an immutable, validated MiniLang scene description (`refdef` equivalent) and
uses a thin driver bridge. It does not read client globals through native
pointers. Renderer resources are generation-checked handles and become invalid
at the same lifecycle boundaries as v3 registration.

The original binary renderer DLL ABI and the software renderer are deferred.
Additional backends must consume the same internal renderer contract so they
cannot fork gameplay or client semantics.

## A04: Shared deterministic core

Protocol encode/decode, pmove, collision, PVS/PHS, area portals, checksums,
random fixtures, and file-format parsing are pure or explicitly stateful
MiniLang modules. Client and server must call the same pmove and qcommon
implementation rather than maintain near-duplicates.

All binary reads are little-endian, length-checked, overflow-checked, and
return classified errors. Untrusted downloads and network messages never
become trusted filesystem paths. Parsers use declared limits from the 3.19
headers and reject truncation, invalid counts, bad offsets, and overlapping
ranges where unsafe.

## A05: Runtime topology

```text
MiniQuake2 executable (MiniLang)
├── qcommon: commands, cvars, filesystem, messages, netchan, checksums
├── collision/formats: BSP38, PAK, MD2, SP2, WAL, PCX, WAV, CIN
├── client: prediction, snapshots, effects, UI, audio scene
├── server: clients, world links, snapshots, multicast, save orchestration
├── baseq2 module behind internal Game API v3
├── renderer behind internal Renderer API v3
│   └── thin native graphics-driver bridge
└── platform facade
    └── thin Win32/input/audio/UDP/time/filesystem bridges
```

Listen server and dedicated server use the same server and game modules. The
dedicated target does not initialize window, renderer, or audio devices.
Loopback transport passes through the same message and netchan contracts as
UDP after the transport boundary.

`runtime/server_session.ml` is the fixed-step product composition for Game API,
collision, UDP/Netchan, and per-client snapshots. `runtime/client_session.ml`
drives the same transport and transactional server-message dispatcher used by
demo replay. Server-provided `stufftext` is data: only the three fixed signon
forms are allowlisted by the headless session; arbitrary text stays queued for
the UI/command-policy layer.

Game-module message writes cross the API-v3 boundary as owned, bounded typed
events. The server resolves `MULTICAST_ALL`, PVS/PHS and their reliable variants
per spawned client; `unicast`, `cprintf` and `centerprintf` resolve exactly one
client edict. Both dispatchers preflight every recipient Netchan before mutation
and drain their bridge queues only after complete delivery. Payloads remain
ordinary Protocol-34 service-command fragments; no private wire framing is
introduced.

## A06: Data ownership and save format

MiniLang owns all long-lived engine state. Native memory is borrowed only for
the duration documented by a bridge call or held behind an explicit release
handle. Renderer and audio callbacks may not retain movable MiniLang memory.

Savegames use a versioned field serializer. An original 3.19 disk-layout
adapter may reproduce/import the Win32 format, including symbolic function
fields, but raw struct dumps, raw pointers, and runtime-specific object images
are prohibited. A failed load must not partially replace the active game.

## A07: Repository and module shape

New MiniLang modules use the `miniquake2.*` namespace and remain separate from
MiniQuake's Quake I implementation. Proven infrastructure may be shared only
through clearly generic libraries or copied with provenance and appropriate
license notices. Quake I limits, protocols, BSP types, globals, and game logic
must never leak into Quake II types merely because their names are similar.

The original source tree is a read-only reference. Every ported function or
approved adapter is linked back to `PORT_LEDGER.json` and acceptance evidence.
