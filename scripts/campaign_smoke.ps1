# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# Read-only full-retail BSP/entity inventory and per-map asset smoke.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$Quake2Root,
  [string]$Executable = "",
  [string]$Python = "py",
  [switch]$AllowSkipped,
  [ValidateRange(0, 39)]
  [int]$SessionMaps = 0,
  [string]$Json = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$Root = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($Executable)) {
  $Executable = Join-Path $Root "build\MiniQuake2.exe"
}
$Tool = Join-Path $Root "tools\retail_campaign_inventory.py"
$ToolTests = Join-Path $Root "tools\test_retail_campaign_inventory.py"
$Arguments = @($Tool, $Quake2Root, "--exe", $Executable)
if (-not $AllowSkipped) { $Arguments += "--require-zero-skips" }
if (-not [string]::IsNullOrWhiteSpace($Json)) { $Arguments += @("--json", $Json) }

if ([System.IO.Path]::GetFileNameWithoutExtension($Python) -ieq "py") {
  & $Python -3 $ToolTests
  if ($LASTEXITCODE -ne 0) { throw "Retail campaign inventory self-test failed with exit code $LASTEXITCODE." }
  & $Python -3 @Arguments
} else {
  & $Python $ToolTests
  if ($LASTEXITCODE -ne 0) { throw "Retail campaign inventory self-test failed with exit code $LASTEXITCODE." }
  & $Python @Arguments
}
if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 retail campaign smoke failed with exit code $LASTEXITCODE." }

$AggregateTest = Join-Path (Split-Path -Parent ([System.IO.Path]::GetFullPath($Executable))) "baseq2_campaign_retail_smoke_tests.exe"
if (Test-Path -LiteralPath $AggregateTest -PathType Leaf) {
  & $AggregateTest $Quake2Root
  if ($LASTEXITCODE -ne 0) { throw "MiniLang single-process retail aggregate failed with exit code $LASTEXITCODE." }
}
if ($SessionMaps -gt 0) {
  & $Executable --campaign-session-smoke $Quake2Root $SessionMaps
  if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 retail campaign session smoke failed with exit code $LASTEXITCODE." }
}
Write-Host "MiniQuake2 retail campaign smoke: PASS" -ForegroundColor Green
