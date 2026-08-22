# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# Exercise the built product against a local retail installation and the active
# Windows graphics/audio devices. Retail data is read in place and never copied.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$Quake2Root,
  [string]$Map = "base1",
  [string]$Cinematic = "idlog",
  [ValidateRange(1, 1000000)]
  [int]$SoakFrames = 20000,
  [ValidateRange(0, 60)]
  [int]$MaximumCinematicDrops = 1,
  [string]$Executable = "",
  [string]$SoakExecutable = "",
  [switch]$SkipCinematic,
  [switch]$SkipSoak
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$Root = Split-Path -Parent $PSScriptRoot

if ([string]::IsNullOrWhiteSpace($Executable)) {
  $Executable = Join-Path $Root "build\MiniQuake2.exe"
}
if ([string]::IsNullOrWhiteSpace($SoakExecutable)) {
  $SoakExecutable = Join-Path $Root "build\runtime_session_soak_tests.exe"
}
if (-not (Test-Path -LiteralPath $Quake2Root -PathType Container)) {
  throw "Quake II retail root not found: $Quake2Root"
}
if (-not (Test-Path -LiteralPath $Executable -PathType Leaf)) {
  throw "MiniQuake2 executable not found: $Executable"
}

function Invoke-AcceptanceCommand {
  param(
    [Parameter(Mandatory = $true)][string]$FilePath,
    [Parameter(Mandatory = $true)][string[]]$Arguments,
    [Parameter(Mandatory = $true)][string]$Label
  )
  $Lines = @(& $FilePath @Arguments 2>&1 | ForEach-Object {
    $Line = [string]$_
    Write-Host $Line
    $Line
  })
  if ($LASTEXITCODE -ne 0) { throw "$Label failed with exit code $LASTEXITCODE." }
  return ($Lines -join "`n")
}

Write-Host "[MiniQuake2] local host" -ForegroundColor Cyan
Get-CimInstance Win32_OperatingSystem |
  Select-Object Caption, Version, BuildNumber, OSArchitecture |
  Format-Table -AutoSize
Get-CimInstance Win32_Processor |
  Select-Object Name, NumberOfCores, NumberOfLogicalProcessors |
  Format-Table -AutoSize
Get-CimInstance Win32_VideoController |
  Select-Object Name, DriverVersion, VideoModeDescription, Status |
  Format-Table -AutoSize
Get-CimInstance Win32_SoundDevice |
  Where-Object Status -eq "OK" |
  Select-Object Name, Manufacturer, Status |
  Format-Table -AutoSize

Write-Host "[MiniQuake2] live OpenGL restart" -ForegroundColor Cyan
$Video = Invoke-AcceptanceCommand -FilePath $Executable -Arguments @(
  "--video-restart-smoke", $Quake2Root, $Map
) -Label "video restart"
if ($Video -notmatch "generation=2 mode=([0-9]+)x([0-9]+).*fullscreen=true" -or
    $Video -notmatch "visible-before=([0-9]+) visible-after=([0-9]+)") {
  throw "Video restart output is incomplete."
}
$VisibleBefore = [int]$Matches[1]
$VisibleAfter = [int]$Matches[2]
if ($VisibleBefore -le 0 -or $VisibleAfter -ne $VisibleBefore) {
  throw "Video restart did not preserve the visible retail world."
}

if (-not $SkipCinematic) {
  Write-Host "[MiniQuake2] retail cinematic and native audio device" -ForegroundColor Cyan
  $CinematicOutput = Invoke-AcceptanceCommand -FilePath $Executable -Arguments @(
    "--cinematic", $Quake2Root, $Cinematic, "0", "0"
  ) -Label "cinematic/audio"
  if ($CinematicOutput -notmatch "completions=1 dropped=([0-9]+)") {
    throw "Cinematic completion metrics are missing."
  }
  $CinematicDrops = [int]$Matches[1]
  if ($CinematicDrops -gt $MaximumCinematicDrops -or
      $CinematicOutput -notmatch "audio-device=true") {
    throw "Cinematic did not complete cleanly through the native audio device."
  }
}

if (-not $SkipSoak) {
  if (-not (Test-Path -LiteralPath $SoakExecutable -PathType Leaf)) {
    throw "Session soak executable not found: $SoakExecutable"
  }
  Write-Host "[MiniQuake2] retail UDP/Game-API lifetime soak" -ForegroundColor Cyan
  $Soak = Invoke-AcceptanceCommand -FilePath $SoakExecutable -Arguments @(
    $Quake2Root, $Map, [string]$SoakFrames
  ) -Label "retail session soak"
  if ($Soak -notmatch "runtime_session_soak_tests: PASS \(retail\)" -or
      $Soak -notmatch "rejected=0") {
    throw "Retail session soak output is incomplete."
  }
}

Write-Host "MiniQuake2 local hardware acceptance: PASS" -ForegroundColor Green
