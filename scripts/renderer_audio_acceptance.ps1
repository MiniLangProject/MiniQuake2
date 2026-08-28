# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# Reproduce original-ref_gl, deterministic inline-renderer and PCM replay gates.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$RetailRoot,
  [string]$OutputDirectory = "",
  [string]$Compiler = "",
  [string]$StdLib = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$Root = Split-Path -Parent $PSScriptRoot
$Parent = Split-Path -Parent $Root
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
  $OutputDirectory = Join-Path $Root "build\renderer_audio_acceptance"
}
$OutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)
if ([string]::IsNullOrWhiteSpace($Compiler)) {
  $Compiler = Join-Path $Parent "MiniLangCompilerPy\mlc_win64.py"
}
if ([string]::IsNullOrWhiteSpace($StdLib)) { $StdLib = Split-Path -Parent $Compiler }
New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null

$RendererOutput = Join-Path $OutputDirectory "renderer"
& (Join-Path $Root "tools\run_ref_gl_differential.ps1") `
  -RetailRoot $RetailRoot -OutputDirectory $RendererOutput `
  -Compiler $Compiler -StdLib $StdLib
if ($LASTEXITCODE -ne 0) { throw "renderer differential/replay acceptance failed" }

$AudioExe = Join-Path $OutputDirectory "audio_replay_tests.exe"
$AudioArguments = @(
  (Join-Path $Root "tests\audio_replay_tests.ml"), $AudioExe,
  "-I", (Join-Path $Root "src"), "-I", (Join-Path $Root "native"), "-I", $StdLib,
  "--heap-reserve", "256m", "--heap-commit", "16m", "--heap-grow", "4m",
  "--gc-limit", "4m"
)
if ([System.IO.Path]::GetExtension($Compiler) -ieq ".py") {
  & py -3 $Compiler @AudioArguments
} else {
  & $Compiler @AudioArguments
}
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $AudioExe -PathType Leaf)) {
  throw "audio replay compilation failed"
}
foreach ($RuntimeDll in Get-ChildItem -LiteralPath (Join-Path $Root "native") -Filter "*.dll" -File) {
  Copy-Item -Force -LiteralPath $RuntimeDll.FullName -Destination (
    Join-Path $OutputDirectory $RuntimeDll.Name)
}
$AudioFirst = @(& $AudioExe 2>&1)
if ($LASTEXITCODE -ne 0) { throw "first audio replay failed" }
$AudioSecond = @(& $AudioExe 2>&1)
if ($LASTEXITCODE -ne 0) { throw "second audio replay failed" }
$AudioFirstText = $AudioFirst -join "`n"
$AudioSecondText = $AudioSecond -join "`n"
if ($AudioFirstText -ne $AudioSecondText -or $AudioFirstText -notmatch "checksum=630146404") {
  throw "audio replay output was not byte-golden and repeatable"
}
($AudioFirst + $AudioSecond) | Set-Content -LiteralPath (Join-Path $OutputDirectory "audio_replay.log") -Encoding UTF8

$RendererSummary = Get-Content -LiteralPath (Join-Path $RendererOutput "summary.json") -Raw | ConvertFrom-Json
$Summary = [ordered]@{
  schema = "miniquake2.renderer-audio-acceptance.v1"
  renderer = $RendererSummary
  audio = [ordered]@{
    frames = 512
    pcm_bytes = 2048
    fnv1a = 630146404
    independent_runs = 2
    pass = $true
  }
  pass = $true
}
$SummaryPath = Join-Path $OutputDirectory "summary.json"
$Summary | ConvertTo-Json -Depth 16 | Set-Content -LiteralPath $SummaryPath -Encoding UTF8
Write-Host "MiniQuake2 renderer/audio acceptance: PASS" -ForegroundColor Green
Write-Host "  paired-scenes=$($RendererSummary.scenes.Count) deterministic-replays=$($RendererSummary.deterministic_replays.Count)"
Write-Host "  audio-fnv1a=630146404 pcm-bytes=2048"
Write-Host "  report=$SummaryPath"
