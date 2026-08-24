# Original `ref_gl` Differential Gate

This gate compares MiniQuake2 with an installed, unmodified classic Quake II
OpenGL renderer. It does not copy the DLL or retail assets into the repository.
Both renderers read the user's installation in place and write derived TGA
captures only below `build/`.

## Reference and host contract

The accepted local reference is the installed 32-bit Renderer API v3 binary:

| File | Size | SHA-256 |
|---|---:|---|
| `ref_gl.dll` | 234,496 bytes | `7A66C91988AB406DDC42F3C24D1539E2808222C89259DF1B0CAB21A533D5B5A5` |

`tools/original_ref_gl_capture.c` is a small x86 API-v3 host. It provides the
original renderer with a Win32/OpenGL context, cvars and read-only loose/PAK
filesystem callbacks. It calls the exported `GetRefAPI`, registers the world
and optional MD2 model, submits one fixed `refdef_t`, reads the back buffer, and
writes a canonical top-left 32-bit TGA. `tools/original_ref_gl_capture.ps1`
builds the host with Visual Studio's x86 tools and records the DLL hash.

The paired gate deliberately omits inline BSP entities. Their transforms are
runtime mover state, not a trustworthy static projection of the BSP entity
lump. Inline-brush geometry, transforms, lightmaps and alpha ordering retain
their dedicated native goldens; the paired scenes isolate comparable world and
MD2 submissions.

## Fixed scenes and thresholds

All three paired scenes use 640x480, four frames and capture time 0.3 seconds.

| Scene | Camera `x y z pitch yaw roll` | Additional coverage |
|---|---|---|
| `base1_world` | `-1768 1536 150 0 0 0` | opaque BSP, PVS, static lightmaps |
| `waste1_world_md2` | `-2192 1796 -366 0 270 0` | warp/water and fullbright Soldier MD2 |
| `cool1_alpha_md2` | `-1448 -1520 46 0 90 0` | 56 alpha surfaces and fullbright Soldier MD2 |

The comparison ignores per-channel deltas up to 4 and requires all of:

- no more than 32,000 differing pixels;
- mismatch ratio no more than 100,000 ppm;
- mean absolute RGB error no more than 4,000 ppm.

The current NVIDIA OpenGL compatibility run passes with:

| Scene | Differing pixels | Mismatch ppm | Mean absolute error ppm |
|---|---:|---:|---:|
| `base1_world` | 25,725 | 83,740 | 2,792 |
| `waste1_world_md2` | 10,987 | 35,765 | 2,303 |
| `cool1_alpha_md2` | 16,263 | 52,939 | 2,963 |

The gate exposed a material defect rather than merely documenting it: classic
`ref_gl` scales mipmapped WAL and model-skin RGB through its default
`intensity=2` table. MiniQuake2 now performs the same saturated upload and uses
the original inverse-intensity color for warp and alpha passes. The remaining
small differences are concentrated at filtered texture/lightmap edges and the
MD2 silhouette; exact pixels are not claimed.

## Planar alias-shadow isolation

The capture entry point also accepts a final `SHADOWS(0|1)` argument. This is a
MiniQuake2 on/off isolation check rather than a new paired-original claim:
classic `ref_gl` registers `gl_shadows` disabled by default, and the established
three-scene differential remains unchanged. A one-frame, 640x360 grounded
Soldier capture at the default `base1` spawn retains 324 visible surfaces,
6,983 culled surfaces, nine brush entities, one MD2 and light height 32 in both
runs. Enabling the shadow changes only `shadowEntities` from zero to one and
produces 2,058 differing pixels, 5,990 differing RGB channels, 29,396 absolute
error, maximum channel delta 17 and 167-ppm mean absolute error. This proves a
visible black alpha-0.5 projection without conflating it with camera, world or
entity-count changes.

The same command captures four independent MiniQuake2 runs twice and requires
zero differing pixels. These scenes enable inline BSP models whose live mover
transforms cannot be reconstructed authoritatively by a static original host:

| Replay | Coverage | TGA SHA-256 |
|---|---|---|
| `base1_inline` | opaque world and inline movers | `DDB0D0F2D0248E9C4D040E443C7D9368DDF00B056BD5E966B4B7E7C78300DDEC` |
| `waste1_water_inline_md2` | 20 warp surfaces, 22 inline brushes, MD2 | `E41051C6B099D9D1353AE649B148DD811E637267D6B889EFCE5A7AB3467887BA` |
| `cool1_alpha_inline_md2` | 56 alpha surfaces, 20 inline brushes, MD2 | `3C1736908C0790ACA73162350E9D7EA14F255E032288A2B6B8597153571E93D5` |
| `boss2_sky_inline_md2` | sky, alpha, 11 inline brushes, MD2 | `A3208B1A63169ACBC2B90BC24402E24E032CD0F318975A200B1A290782D80B0B` |

## Reproduce

From `MiniQuake2`:

```powershell
.\tools\run_ref_gl_differential.ps1 `
  -RetailRoot "C:\Program Files (x86)\Steam\steamapps\common\Quake 2"
```

The command compiles the current MiniLang capture entry point, builds the x86
original host, runs all paired scenes and deterministic replays, verifies the reference hash, and emits
TGA pairs, heatmaps, per-scene JSON and `summary.json` under
`build/ref_gl_differential/`. A different classic DLL is rejected unless the
caller explicitly supplies `-AllowDifferentReferenceBinary`; such a run is new
evidence and must not silently replace the accepted baseline.

The combined renderer/audio entry point additionally compiles and runs the
byte-golden PCM replay:

```powershell
.\scripts\renderer_audio_acceptance.ps1 `
  -RetailRoot "C:\Program Files (x86)\Steam\steamapps\common\Quake 2"
```
