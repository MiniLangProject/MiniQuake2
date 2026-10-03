# MiniQuake2 v0.5.0-foundation (Windows x64)

This first GitHub release packages the native Windows engine and its runtime
DLLs. It is built with MiniLang Compiler 1.2.16 from the current source tree.
The packaging script now accepts explicit compiler and standard-library paths
so the release build can be reproduced with the self-hosted compiler.

In a local 500-frame `base1` measurement, engine-work FPS was 54.6 with the
historical Compiler 1.2.0 and 54.4 with 1.2.16 (median of two runs per version).
The new EXE is about 22% smaller. The frame rate difference is negligible at
this measurement scale.

The archive does not contain Quake II data. Supply a legal installation with
`baseq2/pak0.pak`.
