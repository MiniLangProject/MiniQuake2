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

Both scenes use 640x480, four frames and capture time 0.3 seconds.

| Scene | Camera `x y z pitch yaw roll` | Additional coverage |
|---|---|---|
| `base1_world` | `-1768 1536 150 0 0 0` | opaque BSP, PVS, static lightmaps |
| `waste1_world_md2` | `-2192 1796 -366 0 270 0` | warp/water and fullbright Soldier MD2 |

The comparison ignores per-channel deltas up to 4 and requires all of:

- no more than 32,000 differing pixels;
- mismatch ratio no more than 100,000 ppm;
- mean absolute RGB error no more than 4,000 ppm.

The current NVIDIA OpenGL compatibility run passes with:

| Scene | Differing pixels | Mismatch ppm | Mean absolute error ppm |
|---|---:|---:|---:|
| `base1_world` | 25,725 | 83,740 | 2,792 |
| `waste1_world_md2` | 10,987 | 35,765 | 2,303 |

The gate exposed a material defect rather than merely documenting it: classic
`ref_gl` scales mipmapped WAL and model-skin RGB through its default
`intensity=2` table. MiniQuake2 now performs the same saturated upload and uses
the original inverse-intensity color for warp and alpha passes. The remaining
small differences are concentrated at filtered texture/lightmap edges and the
MD2 silhouette; exact pixels are not claimed.

## Reproduce

From `MiniQuake2`:

```powershell
.\tools\run_ref_gl_differential.ps1 `
  -RetailRoot "C:\Program Files (x86)\Steam\steamapps\common\Quake 2"
```

The command compiles the current MiniLang capture entry point, builds the x86
original host, runs both fixed scenes, verifies the reference hash, and emits
TGA pairs, heatmaps, per-scene JSON and `summary.json` under
`build/ref_gl_differential/`. A different classic DLL is rejected unless the
caller explicitly supplies `-AllowDifferentReferenceBinary`; such a run is new
evidence and must not silently replace the accepted baseline.
