# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: GPL-2.0-or-later
# Build and run the x86 API-v3 host against an installed, unmodified ref_gl.dll.

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$RetailRoot,
  [Parameter(Mandatory = $true)][string]$Map,
  [Parameter(Mandatory = $true)][string]$Output,
  [string]$Model = "-",
  [int]$Width = 640,
  [int]$Height = 480,
  [int]$Frames = 4,
  [int]$Inline = 1,
  [double[]]$Camera = @()
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Source = Join-Path $PSScriptRoot "original_ref_gl_capture.c"
$Build = Join-Path $Root "build\original_ref_gl"
$Exe = Join-Path $Build "original_ref_gl_capture.exe"
$Object = Join-Path $Build "original_ref_gl_capture.obj"
$RetailDll = Join-Path $RetailRoot "ref_gl.dll"
if (-not (Test-Path -LiteralPath $RetailDll -PathType Leaf)) { throw "ref_gl.dll not found: $RetailDll" }

$VcVars = Get-ChildItem "C:\Program Files\Microsoft Visual Studio" -Filter "vcvars32.bat" -Recurse -ErrorAction SilentlyContinue |
  Sort-Object FullName -Descending | Select-Object -First 1
if ($null -eq $VcVars) { throw "Visual Studio x86 build tools are required." }
New-Item -ItemType Directory -Force -Path $Build | Out-Null
$Compile = '"{0}" >nul && cl.exe /nologo /O2 /W4 /Fo"{1}" /Fe:"{2}" "{3}" opengl32.lib user32.lib gdi32.lib' -f
  $VcVars.FullName, $Object, $Exe, $Source
& cmd.exe /d /s /c $Compile
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $Exe -PathType Leaf)) { throw "original ref_gl harness compilation failed." }

$Arguments = @($RetailRoot, $Map, $Output, $Model, $Width, $Height, $Frames, $Inline)
if ($Camera.Count -ne 0) {
  if ($Camera.Count -ne 6) { throw "Camera must contain X,Y,Z,PITCH,YAW,ROLL." }
  $Arguments += $Camera
}
& $Exe @Arguments
if ($LASTEXITCODE -ne 0) { throw "original ref_gl capture failed with exit code $LASTEXITCODE." }

$Hash = (Get-FileHash -LiteralPath $RetailDll -Algorithm SHA256).Hash.ToLowerInvariant()
Write-Host "original ref_gl binary sha256=$Hash"
