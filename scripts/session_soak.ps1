# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# Run the already-built unpaced UDP/Game-API soak against legal retail data.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$Quake2Root,
  [string]$Map = "base1",
  [ValidateRange(1, 1000000)]
  [int]$Frames = 100000,
  [string]$Executable = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$Root = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($Executable)) {
  $Executable = Join-Path $Root "build\runtime_session_soak_tests.exe"
}
if (-not (Test-Path -LiteralPath $Executable -PathType Leaf)) {
  throw "Soak executable not found; run build.ps1 first: $Executable"
}
& $Executable $Quake2Root $Map $Frames
if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 session soak failed with exit code $LASTEXITCODE." }
Write-Host "MiniQuake2 session soak: PASS" -ForegroundColor Green
