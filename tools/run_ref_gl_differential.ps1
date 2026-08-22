# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: GPL-2.0-or-later
# Paired fixed-camera captures from MiniQuake2 and an installed classic ref_gl.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$RetailRoot,
  [string]$OutputDirectory = "",
  [string]$Compiler = "",
  [string]$StdLib = "",
  [switch]$AllowDifferentReferenceBinary,
  [int]$ChannelTolerance = 4,
  [int]$MaxDifferingPixels = 32000,
  [int]$MaxMismatchRatioPpm = 100000,
  [int]$MaxMeanAbsoluteErrorPpm = 4000
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$Root = Split-Path -Parent $PSScriptRoot
$Parent = Split-Path -Parent $Root
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
  $OutputDirectory = Join-Path $Root "build\ref_gl_differential"
}
$OutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)
$ReferenceDll = Join-Path $RetailRoot "ref_gl.dll"
$ExpectedReferenceHash = "7a66c91988ab406ddc42f3c24d1539e2808222c89259df1b0cab21a533d5b5a5"

if (-not (Test-Path -LiteralPath (Join-Path $RetailRoot "baseq2\pak0.pak") -PathType Leaf)) {
  throw "Retail baseq2/pak0.pak not found below: $RetailRoot"
}
if (-not (Test-Path -LiteralPath $ReferenceDll -PathType Leaf)) {
  throw "Classic ref_gl.dll not found: $ReferenceDll"
}
$ReferenceHash = (Get-FileHash -LiteralPath $ReferenceDll -Algorithm SHA256).Hash.ToLowerInvariant()
if (-not $AllowDifferentReferenceBinary -and $ReferenceHash -ne $ExpectedReferenceHash) {
  throw "Unexpected ref_gl.dll SHA-256 $ReferenceHash; expected $ExpectedReferenceHash. Use -AllowDifferentReferenceBinary only for an explicitly reviewed classic build."
}

if ([string]::IsNullOrWhiteSpace($Compiler)) {
  $Compiler = Join-Path $Parent "MiniLangCompilerPy\mlc_win64.py"
}
if ([string]::IsNullOrWhiteSpace($StdLib)) {
  $StdLib = Split-Path -Parent $Compiler
}
if (-not (Test-Path -LiteralPath $Compiler -PathType Leaf)) { throw "MiniLang compiler not found: $Compiler" }
if (-not (Test-Path -LiteralPath (Join-Path $StdLib "std\fs.ml") -PathType Leaf)) { throw "MiniLang stdlib not found: $StdLib" }

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
$MiniCapture = Join-Path $OutputDirectory "retail_visual_capture.exe"
$CompilerArguments = @(
  (Join-Path $Root "tools\retail_visual_capture.ml"), $MiniCapture,
  "-I", (Join-Path $Root "src"),
  "-I", (Join-Path $Root "native"),
  "-I", $StdLib,
  "--heap-reserve", "1g", "--heap-commit", "32m", "--heap-grow", "16m", "--gc-limit", "128m"
)
if ([System.IO.Path]::GetExtension($Compiler) -ieq ".py") {
  & py -3 $Compiler @CompilerArguments
} else {
  & $Compiler @CompilerArguments
}
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $MiniCapture -PathType Leaf)) {
  throw "MiniQuake2 visual-capture tool compilation failed."
}
Copy-Item -Force -Path (Join-Path $Root "native\*.dll") -Destination $OutputDirectory

$Scenes = @(
  [pscustomobject]@{
    Name = "base1_world"; Map = "base1"; Model = "-"; Inline = 0
    Camera = @(-1768.0, 1536.0, 150.0, 0.0, 0.0, 0.0)
  },
  [pscustomobject]@{
    Name = "waste1_world_md2"; Map = "waste1"; Model = "models/monsters/soldier/tris.md2"; Inline = 0
    Camera = @(-2192.0, 1796.0, -366.0, 0.0, 270.0, 0.0)
  }
)

$Reports = @()
foreach ($Scene in $Scenes) {
  $OriginalTga = Join-Path $OutputDirectory ("original_" + $Scene.Name + ".tga")
  $MiniTga = Join-Path $OutputDirectory ("miniquake2_" + $Scene.Name + ".tga")
  $Heatmap = Join-Path $OutputDirectory ("diff_" + $Scene.Name + ".tga")
  $Report = Join-Path $OutputDirectory ($Scene.Name + ".json")
  $OriginalLog = Join-Path $OutputDirectory ("original_" + $Scene.Name + ".log")
  $MiniLog = Join-Path $OutputDirectory ("miniquake2_" + $Scene.Name + ".log")

  $OriginalParameters = @{
    RetailRoot = $RetailRoot; Map = $Scene.Map; Output = $OriginalTga
    Model = $Scene.Model; Width = 640; Height = 480; Frames = 4
    Inline = $Scene.Inline; Camera = $Scene.Camera
  }
  $OriginalLines = @(& (Join-Path $PSScriptRoot "original_ref_gl_capture.ps1") @OriginalParameters 2>&1)
  $OriginalLines | Set-Content -LiteralPath $OriginalLog -Encoding UTF8

  $MiniArguments = @($RetailRoot, $Scene.Map, $MiniTga, $Scene.Model, 640, 480, 4, $Scene.Inline) + $Scene.Camera
  $MiniLines = @(& $MiniCapture @MiniArguments 2>&1)
  if ($LASTEXITCODE -ne 0) { throw "MiniQuake2 capture failed for $($Scene.Name)." }
  $MiniLines | Set-Content -LiteralPath $MiniLog -Encoding UTF8

  & py -3 (Join-Path $Root "tools\visual_compare.py") $OriginalTga $MiniTga `
    --channel-tolerance $ChannelTolerance `
    --max-differing-pixels $MaxDifferingPixels `
    --max-mismatch-ratio-ppm $MaxMismatchRatioPpm `
    --max-mean-absolute-error-ppm $MaxMeanAbsoluteErrorPpm `
    --diff-output $Heatmap --json-output $Report
  if ($LASTEXITCODE -ne 0) { throw "ref_gl differential failed for $($Scene.Name); see $Report" }
  $Reports += Get-Content -LiteralPath $Report -Raw | ConvertFrom-Json
}

$Summary = [ordered]@{
  schema = "miniquake2.ref-gl-differential.v1"
  reference = [ordered]@{ path = $ReferenceDll; sha256 = $ReferenceHash }
  dimensions = "640x480"
  frames = 4
  thresholds = [ordered]@{
    channel_tolerance = $ChannelTolerance
    max_differing_pixels = $MaxDifferingPixels
    max_mismatch_ratio_ppm = $MaxMismatchRatioPpm
    max_mean_absolute_error_ppm = $MaxMeanAbsoluteErrorPpm
  }
  scenes = $Reports
  pass = $true
}
$SummaryPath = Join-Path $OutputDirectory "summary.json"
$Summary | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $SummaryPath -Encoding UTF8
Write-Host "MiniQuake2 original ref_gl differential: PASS" -ForegroundColor Green
Write-Host "  reference-sha256=$ReferenceHash"
foreach ($Report in $Reports) {
  Write-Host ("  {0}: pixels={1}, mismatch-ppm={2}, mae-ppm={3}" -f `
    ([System.IO.Path]::GetFileNameWithoutExtension($Report.actual.path)), `
    $Report.metrics.differing_pixels, $Report.metrics.mismatch_ratio_ppm, $Report.metrics.mean_absolute_error_ppm)
}
Write-Host "  report=$SummaryPath"
