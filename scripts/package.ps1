# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0

[CmdletBinding()]
param(
  [string]$Version = "0.5.0-foundation",
  [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Workspace = Split-Path -Parent $Root
if (-not $SkipBuild) {
  & (Join-Path $Root "build.ps1") -Configuration Release -UpdateManifest
  if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 release build failed." }
}
py -3 (Join-Path $Root "tools\package_release.py") --root $Root --version $Version
if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 packaging failed." }
$BinaryArchive = Join-Path $Root ("build\MiniQuake2-{0}-win64.zip" -f $Version)
py -3 (Join-Path $Root "tools\package_runtime_smoke.py") --archive $BinaryArchive
if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 packaged runtime smoke failed." }
