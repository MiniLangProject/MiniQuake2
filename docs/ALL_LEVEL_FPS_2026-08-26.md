# All-Level FPS Report — 2026-08-26

This report measures every user-owned Quake II `baseq2` BSP through the
Release MiniQuake2 product path after the August 2026 performance and bug
audit. No retail file was copied or modified.

## Host and method

- Windows 11 Pro 10.0.26200 build 26200;
- AMD Ryzen 9 9900X, 12 cores / 24 logical processors;
- NVIDIA GeForce RTX 5080, driver 32.0.15.9649;
- windowed 1280x720 OpenGL product mode;
- MiniLang Python compiler 1.1.0 Release output;
- 500 real product frames per map, including the first active frame;
- one fresh process and map load per row;
- 39 single-player maps and 8 deathmatch maps discovered directly from the
  user's PAK directory.

`Engine work FPS` is `rendered frames / measured active frame work`. It
excludes the deliberate 125-Hz frame-cap wait and process/map startup. `Wall
FPS` includes process startup, map loading, registration, warm-up, the cap and
the 500 measured frames, so it is intentionally lower. `Max frame` includes
the first active frame and controlled collection tails.

Reproduce with:

```powershell
py -3 tools\retail_fps_report.py "C:\Games\Quake2" `
  --exe build\MiniQuake2.exe --frames 500 --scope all `
  --json build\retail_fps_all_levels.json `
  --csv build\retail_fps_all_levels.csv
```

## Summary

| Scope | Maps | Minimum | Median | Mean | Maximum |
|---|---:|---:|---:|---:|---:|
| All maps | 47 | 133.26 | 457.31 | 457.53 | 724.23 |
| Single player | 39 | 133.26 | 457.31 | 454.64 | 724.23 |
| Deathmatch | 8 | 203.71 | 480.72 | 471.61 | 683.05 |

All 47 runs passed. They reported zero missing play assets, zero audio
underruns and 46 controlled collections in aggregate. The worst observed
single active frame was 257.24 ms; the eight-buffer audio queue absorbed every
collection/start-frame tail in this matrix.

## Results

| Map | Engine work FPS | Mean work ms | Wall FPS | Max frame ms | Collections | Underruns |
|---|---:|---:|---:|---:|---:|---:|
| base1 | 431.17 | 2.319 | 85.85 | 137.85 | 1 | 0 |
| base2 | 430.14 | 2.325 | 81.47 | 243.16 | 1 | 0 |
| base3 | 373.92 | 2.674 | 81.08 | 137.82 | 1 | 0 |
| biggun | 545.64 | 1.833 | 87.46 | 188.98 | 1 | 0 |
| boss1 | 501.97 | 1.992 | 84.27 | 131.19 | 1 | 0 |
| boss2 | 674.44 | 1.483 | 83.29 | 135.18 | 1 | 0 |
| bunk1 | 390.10 | 2.563 | 72.55 | 172.63 | 1 | 0 |
| city1 | 719.54 | 1.390 | 79.74 | 129.41 | 1 | 0 |
| city2 | 383.72 | 2.606 | 77.07 | 175.71 | 1 | 0 |
| city3 | 550.23 | 1.817 | 73.27 | 130.93 | 1 | 0 |
| command | 374.26 | 2.672 | 76.07 | 179.33 | 1 | 0 |
| cool1 | 183.23 | 5.458 | 73.34 | 176.41 | 1 | 0 |
| fact1 | 578.03 | 1.730 | 80.46 | 132.92 | 1 | 0 |
| fact2 | 165.29 | 6.050 | 67.80 | 138.52 | 2 | 0 |
| fact3 | 133.26 | 7.504 | 84.68 | 252.58 | 2 | 0 |
| hangar1 | 609.44 | 1.641 | 80.78 | 257.24 | 1 | 0 |
| hangar2 | 450.22 | 2.221 | 76.15 | 166.51 | 1 | 0 |
| jail1 | 423.18 | 2.363 | 78.77 | 174.51 | 1 | 0 |
| jail2 | 533.36 | 1.875 | 79.45 | 130.00 | 1 | 0 |
| jail3 | 539.64 | 1.853 | 78.54 | 165.45 | 1 | 0 |
| jail4 | 527.97 | 1.894 | 78.17 | 134.17 | 1 | 0 |
| jail5 | 352.27 | 2.839 | 78.07 | 166.07 | 1 | 0 |
| lab | 540.60 | 1.850 | 70.64 | 132.43 | 0 | 0 |
| mine1 | 279.38 | 3.579 | 75.81 | 216.06 | 1 | 0 |
| mine2 | 591.69 | 1.690 | 79.19 | 131.44 | 1 | 0 |
| mine3 | 221.53 | 4.514 | 77.61 | 135.42 | 1 | 0 |
| mine4 | 304.76 | 3.281 | 82.68 | 131.46 | 1 | 0 |
| mintro | 724.23 | 1.381 | 82.39 | 183.65 | 1 | 0 |
| power1 | 457.31 | 2.187 | 82.07 | 181.14 | 1 | 0 |
| power2 | 604.40 | 1.655 | 75.80 | 135.14 | 1 | 0 |
| q2dm1 | 683.05 | 1.464 | 91.89 | 213.56 | 0 | 0 |
| q2dm2 | 412.06 | 2.427 | 91.65 | 176.05 | 1 | 0 |
| q2dm3 | 203.71 | 4.909 | 75.42 | 178.45 | 0 | 0 |
| q2dm4 | 305.61 | 3.272 | 83.02 | 173.16 | 1 | 0 |
| q2dm5 | 662.37 | 1.510 | 92.68 | 162.77 | 0 | 0 |
| q2dm6 | 366.09 | 2.732 | 88.07 | 174.20 | 1 | 0 |
| q2dm7 | 549.39 | 1.820 | 93.58 | 132.82 | 1 | 0 |
| q2dm8 | 590.60 | 1.693 | 90.09 | 178.17 | 2 | 0 |
| security | 521.91 | 1.916 | 84.28 | 158.06 | 1 | 0 |
| space | 487.90 | 2.050 | 78.18 | 172.62 | 1 | 0 |
| strike | 677.07 | 1.477 | 85.36 | 129.10 | 1 | 0 |
| train | 547.69 | 1.826 | 81.57 | 173.65 | 1 | 0 |
| ware1 | 260.44 | 3.840 | 68.39 | 132.61 | 1 | 0 |
| ware2 | 297.18 | 3.365 | 70.98 | 131.39 | 1 | 0 |
| waste1 | 333.35 | 3.000 | 76.42 | 137.82 | 1 | 0 |
| waste2 | 402.78 | 2.483 | 81.86 | 228.21 | 1 | 0 |
| waste3 | 607.85 | 1.645 | 80.91 | 130.82 | 1 | 0 |

## Audit improvement

The first whole-matrix run exposed multi-second heap-commit stalls on three
dense maps. Loading retains the 1,536-MiB horizon with explicit phase-boundary
collections; active gameplay now uses a 256-MiB allocation horizon. Pusher and
body snapshots are also retained as runtime-owned scratch storage.

| Map | Before FPS | Final FPS | Before max ms | Final max ms | Before underruns | Final underruns |
|---|---:|---:|---:|---:|---:|---:|
| fact2 | 17.72 | 165.29 | 2,856.83 | 138.52 | 16 | 0 |
| ware1 | 7.27 | 260.44 | 5,960.08 | 132.61 | 25 | 0 |
| ware2 | 39.21 | 297.18 | 1,726.26 | 131.39 | 11 | 0 |

The before values are retained only as audit evidence and are not part of the
final aggregate. The final machine-readable JSON/CSV remain ignored build
artifacts and can be regenerated with the command above.
