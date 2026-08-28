# Native bridges

MiniQuake2 owns the complete source and deterministic build inputs for its two
checked-in Windows x64 platform/text bridges. No sibling MiniQuake checkout is
required. MiniQuake2 uses only the operating-system, device, UDP, audio, input,
text, Ogg Vorbis, and OpenGL entry points declared by
`src/miniquake2/native.ml`; gameplay, protocol, collision, scene composition,
and file-format policy remain in MiniLang.

| Binary | SHA-256 |
| --- | --- |
| `miniquake_native.dll` | `4c25f48ba803962ac093f2688bc17d6811651421fdd11fe1fba7021f8a41b2b0` |
| `miniquake_text.dll` | `80cf53dcc598997d7794083fdf62f11539811c887f23d77adb4551f48b0382cb` |

The corresponding C sources, module-definition files, compatibility headers,
and deterministic Python build scripts live in this directory. Vendored
decoder and Vulkan headers live below `../third_party` with their upstream
license files.

Rebuild both bridges and the MiniLang product from the repository root:

```powershell
.\build.ps1 -RebuildNative
```

`build_bridge.py` prefers `clang-cl`/`lld-link` and falls back to an installed
x64 MSVC toolchain. The build does not read any file from MiniQuake.
