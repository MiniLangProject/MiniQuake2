# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# Build, package and extracted-smoke-test the deterministic release archives.

[CmdletBinding()]
param(
  [string]$Version = "0.5.1-foundation",
  [string]$Compiler = "",
  [string]$StdLib = "",
  [string]$Upx = "",
  [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Workspace = Split-Path -Parent $Root
if (-not $SkipBuild) {
  # GitHub release archives use the measured deployment profile: a packed
  # product executable and the Windows background collector.  The ordinary
  # build.ps1 defaults remain available for throughput-focused local work.
  $buildArguments = @{
    Configuration = 'Release'
    UpdateManifest = $true
    ConcurrentGc = $true
    Pack = $true
  }
  if (-not [string]::IsNullOrWhiteSpace($Compiler)) { $buildArguments.Compiler = $Compiler }
  if (-not [string]::IsNullOrWhiteSpace($StdLib)) { $buildArguments.StdLib = $StdLib }
  if (-not [string]::IsNullOrWhiteSpace($Upx)) { $buildArguments.Upx = $Upx }
  & (Join-Path $Root "build.ps1") @buildArguments
  if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 release build failed." }
}
py -3 (Join-Path $Root "tools\package_release.py") --root $Root --version $Version
if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 packaging failed." }
$BinaryArchive = Join-Path $Root ("build\MiniQuake2-{0}-win64.zip" -f $Version)
py -3 (Join-Path $Root "tools\package_runtime_smoke.py") --archive $BinaryArchive
if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 packaged runtime smoke failed." }
