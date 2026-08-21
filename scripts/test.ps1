# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# One-command MiniQuake2 scaffold verification and CLI smoke suite.

[CmdletBinding()]
param(
  [string]$Compiler = "",
  [string]$StdLib = "",
  [string]$Python = "",
  [ValidateSet("Release", "Debug")]
  [string]$Configuration = "Release",
  [switch]$Listings,
  [switch]$SkipPreflight
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$Root = Split-Path -Parent $PSScriptRoot
$Parameters = @{ Configuration = $Configuration }
if (-not [string]::IsNullOrWhiteSpace($Compiler)) { $Parameters.Compiler = $Compiler }
if (-not [string]::IsNullOrWhiteSpace($StdLib)) { $Parameters.StdLib = $StdLib }
if (-not [string]::IsNullOrWhiteSpace($Python)) { $Parameters.Python = $Python }
if ($Listings) { $Parameters.Listings = $true }
if ($SkipPreflight) { $Parameters.SkipPreflight = $true }

& (Join-Path $Root "build.ps1") @Parameters
if (-not $?) { throw "MiniQuake2 build/test entry point failed." }

Write-Host "MiniQuake2 integrated test suite: PASS" -ForegroundColor Green
