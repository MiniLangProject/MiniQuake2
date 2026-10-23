# MiniQuake2 v0.5.1-foundation (Windows x64)

This update packages the current integrated MiniLang port with MiniLang
Compiler 1.2.22. The GitHub release uses a UPX-packed product executable and
the Windows concurrent garbage collector with an 8-MiB SATB limit.

The release also fixes configuration validation for the `cl_maxfps` menu and
config variable, including the supported 30--1000 range. The packaged runtime
continues to require a legal Quake II installation containing `baseq2/pak0.pak`;
no game data is included in either release archive.

The concurrent collector is validated by the complete concurrent-GC parity
matrix, including a regression for a dead function containing a write barrier.
The deployment profile reduces the executable from 55.0 MiB to 5.65 MiB. In
the 1920x1080, VSync-off retail benchmark it made maximum frame times much
more consistent, while its median engine-work throughput was lower on two of
three sampled maps. This is therefore the published distribution profile;
developers can continue to use the unpacked synchronous-GC build for peak
local throughput.
