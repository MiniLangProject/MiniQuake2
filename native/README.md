# Native bridge provenance

The two checked-in DLLs are the verified Windows x64 platform/text bridge
builds shared with the sibling `MiniQuake` project. MiniQuake2 uses only the
operating-system, device, UDP, audio, input, text, and OpenGL entry points
declared by `src/miniquake2/native.ml`; gameplay, protocol, collision, scene
composition, and file-format policy remain in MiniLang.

| Binary | SHA-256 |
| --- | --- |
| `miniquake_native.dll` | `4c25f48ba803962ac093f2688bc17d6811651421fdd11fe1fba7021f8a41b2b0` |
| `miniquake_text.dll` | `b1d7ec43b116c694ea03a0f1a0c2cc58a5fdcb5d009968cb79b157034ad9f16f` |

Corresponding source and deterministic build scripts are retained in the same
workspace at `../MiniQuake/native/`: `miniquake_native.c/.h/.def`,
`miniquake_text.c/.def`, `build_bridge.py`, and `build_text_bridge.py`.
A binary release must include those exact source files and scripts in its
source archive; the DLLs must not be shipped alone.
