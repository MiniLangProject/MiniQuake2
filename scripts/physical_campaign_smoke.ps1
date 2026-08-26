# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# Run the installed-retail campaign through the physical product input path.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$Quake2Root,
  [string]$Executable = "",
  [ValidateRange(8, 10000)]
  [int]$Steps = 48
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($Executable)) {
  $Executable = Join-Path $Root "build\MiniQuake2.exe"
}
$Executable = [System.IO.Path]::GetFullPath($Executable)
$Quake2Root = [System.IO.Path]::GetFullPath($Quake2Root)
if (-not (Test-Path -LiteralPath $Executable -PathType Leaf)) { throw "MiniQuake2 executable not found: $Executable" }
if (-not (Test-Path -LiteralPath (Join-Path $Quake2Root "baseq2\pak0.pak") -PathType Leaf)) {
  throw "Quake II baseq2/pak0.pak not found below: $Quake2Root"
}

$Maps = @(
  "base1", "base2", "base3", "biggun", "boss1", "boss2", "bunk1",
  "city1", "city2", "city3", "command", "cool1", "fact1", "fact2",
  "fact3", "hangar1", "hangar2", "jail1", "jail2", "jail3", "jail4",
  "jail5", "lab", "mine1", "mine2", "mine3", "mine4", "mintro",
  "power1", "power2", "security", "space", "strike", "train", "ware1",
  "ware2", "waste1", "waste2", "waste3"
)

$Passed = 0
$Failures = @()
$Deaths = @()
$ItemDelta = 0
foreach ($Map in $Maps) {
  $Output = @(& $Executable --play-input-smoke $Quake2Root $Map $Steps 2>&1)
  $ExitCode = [int]$LASTEXITCODE
  $Summary = [string]($Output | Where-Object { $_ -match '^  map=' } | Select-Object -First 1)
  if ($ExitCode -ne 0) {
    $Failures += $Map
    Write-Host "FAIL $Map" -ForegroundColor Red
    $Output | ForEach-Object { Write-Host "  $_" }
    continue
  }
  $Passed += 1
  if ($Summary -match 'items=(-?\d+)') { $ItemDelta += [int]$Matches[1] }
  if ($Summary -match 'health=(-?\d+)' -and [int]$Matches[1] -le 0) { $Deaths += $Map }
  Write-Host "PASS $Map $Summary"
}

Write-Host "MiniQuake2 physical campaign smoke: maps=$($Maps.Count) passed=$Passed failed=$($Failures.Count) item-delta=$ItemDelta deaths=$($Deaths.Count)"
if ($Deaths.Count -gt 0) { Write-Host "  death-maps=$($Deaths -join ',')" }
if ($Failures.Count -gt 0) {
  Write-Host "  failed-maps=$($Failures -join ',')" -ForegroundColor Red
  exit 1
}
Write-Host "MiniQuake2 physical campaign smoke: PASS" -ForegroundColor Green
