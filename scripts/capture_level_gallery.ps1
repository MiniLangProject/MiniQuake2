# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# Rebuild the README gallery from authored Quake II campaign spawn viewpoints.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Quake2Root,
  [string]$OutputDirectory = "",
  [string]$Compiler = "",
  [string]$StdLib = "",
  [int]$Frames = 120,
  [ValidateRange(1, 95)][int]$JpegQuality = 88
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$Root = Split-Path -Parent $PSScriptRoot
$Parent = Split-Path -Parent $Root

# Resolve the default output and compiler locations relative to the checkout.
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
  $OutputDirectory = Join-Path $Root "docs\screenshots\levels"
}
if ([string]::IsNullOrWhiteSpace($Compiler)) {
  $Compiler = Join-Path $Parent "MiniLangCompilerPy\mlc_win64.py"
}
if ([string]::IsNullOrWhiteSpace($StdLib)) {
  $StdLib = Split-Path -Parent $Compiler
}

$OutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)
$CaptureRoot = Join-Path $Root "build\level-gallery-capture"
$CaptureExecutable = Join-Path $CaptureRoot "retail_gameplay_capture.exe"
$ConversionTool = Join-Path $Root "tools\convert_level_gallery.py"
$RetailPak = Join-Path $Quake2Root "baseq2\pak0.pak"

if (-not (Test-Path -LiteralPath $RetailPak -PathType Leaf)) {
  throw "Quake II retail data not found: $RetailPak"
}
if (-not (Test-Path -LiteralPath $Compiler -PathType Leaf)) {
  throw "MiniLang compiler not found: $Compiler"
}
if (-not (Test-Path -LiteralPath (Join-Path $StdLib "std\fs.ml") -PathType Leaf)) {
  throw "MiniLang standard library not found below: $StdLib"
}
if (-not (Test-Path -LiteralPath $ConversionTool -PathType Leaf)) {
  throw "Gallery conversion tool not found: $ConversionTool"
}
if ($Frames -lt 1 -or $Frames -gt 1000) {
  throw "Capture frame count must stay inside [1,1000]."
}

New-Item -ItemType Directory -Force -Path $CaptureRoot, $OutputDirectory | Out-Null

# Compile the full product capture entry point against the same runtime as the game.
$CompilerArguments = @(
  (Join-Path $Root "tools\retail_gameplay_capture.ml"),
  $CaptureExecutable,
  "-I", (Join-Path $Root "src"),
  "-I", (Join-Path $Root "native"),
  "-I", $StdLib,
  "--heap-reserve", "2g",
  "--heap-commit", "32m",
  "--heap-grow", "16m",
  "--gc-limit", "256m"
)
if ([System.IO.Path]::GetExtension($Compiler) -ieq ".py") {
  & py -3 $Compiler @CompilerArguments
} else {
  & $Compiler @CompilerArguments
}
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $CaptureExecutable -PathType Leaf)) {
  throw "MiniQuake2 gallery capture compilation failed."
}
Copy-Item -Path (Join-Path $Root "native\*.dll") -Destination $CaptureRoot -Force

# Preserve the product's canonical 39-map campaign order in the README gallery.
$Maps = @(
  "base1", "base2", "base3", "biggun", "boss1", "boss2", "bunk1",
  "city1", "city2", "city3", "command", "cool1", "fact1", "fact2",
  "fact3", "hangar1", "hangar2", "jail1", "jail2", "jail3", "jail4",
  "jail5", "lab", "mine1", "mine2", "mine3", "mine4", "mintro",
  "power1", "power2", "security", "space", "strike", "train", "ware1",
  "ware2", "waste1", "waste2", "waste3"
)

# Capture each authored start with live HUD/view weapon, then discard the staging TGA.
foreach ($Map in $Maps) {
  $Tga = Join-Path $CaptureRoot ($Map + ".tga")
  $Jpeg = Join-Path $OutputDirectory ($Map + ".jpg")
  & $CaptureExecutable $Quake2Root $Map $Tga $Frames
  if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $Tga -PathType Leaf)) {
    throw "Gallery capture failed for map $Map."
  }
  & py -3 $ConversionTool $Tga $Jpeg --quality $JpegQuality
  if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $Jpeg -PathType Leaf)) {
    throw "Gallery conversion failed for map $Map."
  }
  Remove-Item -LiteralPath $Tga -Force
}

Write-Host "MiniQuake2 level gallery: PASS ($($Maps.Count) maps)" -ForegroundColor Green
