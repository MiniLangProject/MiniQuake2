# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# Refresh the maintained-source integrity manifest after an intentional change.

[CmdletBinding()]
param([string]$Python = "")

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$Root = Split-Path -Parent $PSScriptRoot

if ([string]::IsNullOrWhiteSpace($Python)) {
  $Launcher = Get-Command "py" -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($null -ne $Launcher) {
    & $Launcher.Path -3 (Join-Path $Root "tools\verify_project.py") --root $Root --write-manifest --mode all
  } else {
    $Interpreter = Get-Command "python" -ErrorAction Stop | Select-Object -First 1
    & $Interpreter.Path (Join-Path $Root "tools\verify_project.py") --root $Root --write-manifest --mode all
  }
} else {
  & $Python (Join-Path $Root "tools\verify_project.py") --root $Root --write-manifest --mode all
}

if ($LASTEXITCODE -ne 0) {
  throw "MiniQuake2 manifest refresh or verification failed."
}

