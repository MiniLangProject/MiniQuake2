# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
# Build the integrated asset-free MiniQuake2 Windows-x64 runtime and tests.

[CmdletBinding()]
param(
  [string]$Compiler = "",
  [Alias("StdLibPath", "ImportRoot")]
  [string]$StdLib = "",
  [string]$Python = "",
  [ValidateSet("Release", "Debug")]
  [string]$Configuration = "Release",
  [switch]$SkipTests,
  [switch]$NoRunTests,
  [switch]$Listings,
  [switch]$SkipPreflight,
  [switch]$PreflightOnly,
  [switch]$UpdateManifest
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$env:PYTHONUNBUFFERED = "1"

$Root = $PSScriptRoot
$Parent = Split-Path -Parent $Root
$Source = Join-Path $Root "src"
$Native = Join-Path $Root "native"
$Tests = Join-Path $Root "tests"
$Output = if ($Configuration -ieq "Debug") { Join-Path $Root "build_debug" } else { Join-Path $Root "build" }

if ($PreflightOnly -and $SkipPreflight) {
  throw "-PreflightOnly and -SkipPreflight cannot be used together."
}
# Resolve command or file.

function Resolve-CommandOrFile {
  param([Parameter(Mandatory = $true)][string]$Value, [Parameter(Mandatory = $true)][string]$Label)
  if (Test-Path -LiteralPath $Value -PathType Leaf) {
    return [System.IO.Path]::GetFullPath($Value)
  }
  $Command = Get-Command $Value -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($null -ne $Command -and -not [string]::IsNullOrWhiteSpace($Command.Path)) {
    return $Command.Path
  }
  throw "$Label not found: $Value"
}
# Resolve python.

function Resolve-Python {
  param([string]$Requested)
  if (-not [string]::IsNullOrWhiteSpace($Requested)) {
    $Path = Resolve-CommandOrFile $Requested "Python interpreter"
    if ([System.IO.Path]::GetFileNameWithoutExtension($Path) -ieq "py") {
      return [pscustomobject]@{ Path = $Path; Prefix = @("-3") }
    }
    return [pscustomobject]@{ Path = $Path; Prefix = @() }
  }
  $Launcher = Get-Command "py" -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($null -ne $Launcher) {
    return [pscustomobject]@{ Path = $Launcher.Path; Prefix = @("-3") }
  }
  $Interpreter = Get-Command "python" -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($null -ne $Interpreter) {
    return [pscustomobject]@{ Path = $Interpreter.Path; Prefix = @() }
  }
  throw "Python 3 is required for MiniQuake2 verification and the reference compiler."
}
# Normalize std import root.

function Normalize-StdImportRoot {
  param([string]$Candidate)
  if ([string]::IsNullOrWhiteSpace($Candidate)) { return $null }
  $Full = [System.IO.Path]::GetFullPath($Candidate)
  if (Test-Path -LiteralPath $Full -PathType Leaf) {
    if ([System.IO.Path]::GetFileName($Full) -ieq "fs.ml") {
      $Directory = Split-Path -Parent $Full
      if ((Split-Path -Leaf $Directory) -ieq "std") { return Split-Path -Parent $Directory }
    }
    return $null
  }
  if (-not (Test-Path -LiteralPath $Full -PathType Container)) { return $null }
  if (Test-Path -LiteralPath (Join-Path $Full "std\fs.ml") -PathType Leaf) { return $Full }
  if ((Split-Path -Leaf $Full) -ieq "std" -and (Test-Path -LiteralPath (Join-Path $Full "fs.ml") -PathType Leaf)) {
    return Split-Path -Parent $Full
  }
  return $null
}
# Find std import root.

function Find-StdImportRoot {
  param([string]$CompilerPath, [string]$Requested)
  if (-not [string]::IsNullOrWhiteSpace($Requested)) {
    $Resolved = Normalize-StdImportRoot $Requested
    if ($null -eq $Resolved) { throw "MiniLang stdlib not found at '$Requested'." }
    return $Resolved
  }
  $Candidates = @()
  if (-not [string]::IsNullOrWhiteSpace($env:MINILANG_STDLIB)) { $Candidates += $env:MINILANG_STDLIB }
  if (-not [string]::IsNullOrWhiteSpace($env:MINILANG_HOME)) { $Candidates += $env:MINILANG_HOME }
  $CompilerDirectory = Split-Path -Parent $CompilerPath
  $Candidates += @(
    $CompilerDirectory,
    (Split-Path -Parent $CompilerDirectory),
    (Join-Path $Parent "MiniLangCompilerPy"),
    (Join-Path $Parent "MiniLangCompilerML")
  )
  $Seen = @{}
  foreach ($Candidate in $Candidates) {
    if ([string]::IsNullOrWhiteSpace($Candidate)) { continue }
    $Key = [System.IO.Path]::GetFullPath($Candidate).ToLowerInvariant()
    if ($Seen.ContainsKey($Key)) { continue }
    $Seen[$Key] = $true
    $Resolved = Normalize-StdImportRoot $Candidate
    if ($null -ne $Resolved) { return $Resolved }
  }
  throw "MiniLang stdlib not found. Pass -StdLib PATH or set MINILANG_STDLIB."
}
# Invoke checked.

function Invoke-Checked {
  param(
    [Parameter(Mandatory = $true)][string]$Executable,
    [string[]]$Arguments = @(),
    [Parameter(Mandatory = $true)][string]$Label,
    [string]$LogPath = ""
  )
  $Lines = @(& $Executable @Arguments 2>&1 | ForEach-Object { $Line = [string]$_; Write-Host $Line; $Line })
  $ExitCode = [int]$LASTEXITCODE
  if (-not [string]::IsNullOrWhiteSpace($LogPath)) {
    $Lines | Set-Content -LiteralPath $LogPath -Encoding UTF8
  }
  if ($ExitCode -ne 0) { throw "$Label failed with exit code $ExitCode." }
  return [pscustomobject]@{ Lines = $Lines; Text = ($Lines -join "`n"); ExitCode = $ExitCode }
}

$PythonCommand = Resolve-Python $Python
New-Item -ItemType Directory -Force -Path $Output | Out-Null
$Verifier = Join-Path $Root "tools\verify_project.py"
if (-not (Test-Path -LiteralPath $Verifier -PathType Leaf)) { throw "Project verifier missing: $Verifier" }
$SourceHygieneVerifier = Join-Path $Root "tools\source_hygiene.py"
$SourceHygieneTests = Join-Path $Root "tools\test_source_hygiene.py"
$SourceDocumentationVerifier = Join-Path $Root "tools\check_source_documentation.py"
$SourceDocumentationTests = Join-Path $Root "tools\test_source_documentation.py"
$MarkdownHygieneVerifier = Join-Path $Root "tools\markdown_hygiene.py"
$MarkdownHygieneTests = Join-Path $Root "tools\test_markdown_hygiene.py"
if (-not (Test-Path -LiteralPath $SourceHygieneVerifier -PathType Leaf)) {
  throw "Source hygiene verifier missing: $SourceHygieneVerifier"
}
if (-not (Test-Path -LiteralPath $SourceDocumentationVerifier -PathType Leaf)) {
  throw "Source documentation verifier missing: $SourceDocumentationVerifier"
}
if (-not (Test-Path -LiteralPath $MarkdownHygieneVerifier -PathType Leaf)) {
  throw "Markdown hygiene verifier missing: $MarkdownHygieneVerifier"
}

if ($UpdateManifest) {
  $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($Verifier, "--root", $Root, "--write-manifest", "--mode", "all")) -Label "manifest refresh"
}

if (-not $SkipPreflight) {
  Write-Host "[MiniQuake2] source, inventory, manifest and build-hygiene preflight"
  $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($Verifier, "--root", $Root, "--mode", "all", "--json", (Join-Path $Output "source-verification.json"))) -Label "project preflight; after intentional source changes run scripts\update_manifest.ps1"
  $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($SourceHygieneVerifier, "--root", $Root, "--json", (Join-Path $Output "source-hygiene.json"), "--quiet")) -Label "source license/comment hygiene"
  $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($SourceDocumentationVerifier, "--root", $Root)) -Label "source declaration documentation"
  $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($MarkdownHygieneVerifier, "--root", $Root, "--json", (Join-Path $Output "markdown-hygiene.json"), "--quiet")) -Label "Markdown structure/link hygiene"
  if (-not $SkipTests) {
    $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($Verifier, "--self-test")) -Label "verifier self-test"
    if (-not (Test-Path -LiteralPath $SourceHygieneTests -PathType Leaf)) {
      throw "Source hygiene verifier tests missing: $SourceHygieneTests"
    }
    $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($SourceHygieneTests)) -Label "source hygiene verifier tests"
    if (-not (Test-Path -LiteralPath $SourceDocumentationTests -PathType Leaf)) {
      throw "Source documentation verifier tests missing: $SourceDocumentationTests"
    }
    $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($SourceDocumentationTests)) -Label "source documentation verifier tests"
    if (-not (Test-Path -LiteralPath $MarkdownHygieneTests -PathType Leaf)) {
      throw "Markdown hygiene verifier tests missing: $MarkdownHygieneTests"
    }
    $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($MarkdownHygieneTests)) -Label "Markdown hygiene verifier tests"
  }
}

if ($PreflightOnly) {
  Write-Host "MiniQuake2 preflight: PASS" -ForegroundColor Green
  exit 0
}

if ([string]::IsNullOrWhiteSpace($Compiler)) {
  foreach ($Candidate in @(
    (Join-Path $Parent "MiniLangCompilerPy\mlc_win64.py"),
    (Join-Path $Parent "MiniLangCompilerML\build\mlc_win64.exe")
  )) {
    if (Test-Path -LiteralPath $Candidate -PathType Leaf) { $Compiler = $Candidate; break }
  }
}
if ([string]::IsNullOrWhiteSpace($Compiler)) {
  throw "No MiniLang compiler found. Pass -Compiler PATH or place MiniLangCompilerPy beside MiniQuake2."
}
$Compiler = Resolve-CommandOrFile $Compiler "MiniLang compiler"
$CompilerIsPython = [System.IO.Path]::GetExtension($Compiler) -ieq ".py"
$StdImportRoot = Find-StdImportRoot $Compiler $StdLib
$GameExe = Join-Path $Output "MiniQuake2.exe"
$PartialExe = $GameExe + "." + $PID + ".partial.exe"
$CompileLog = Join-Path $Output "compile-miniquake2.log"
if (Test-Path -LiteralPath $PartialExe -PathType Leaf) { Remove-Item -Force -LiteralPath $PartialExe }

$CompilerArguments = @(
  (Join-Path $Source "main.ml"),
  $PartialExe,
  "-I", $Source,
  "-I", $Native,
  "-I", $StdImportRoot,
  "--keep-going", "--max-errors", "50",
  # Retail PAK + BSP renderer preparation retains the classic archives and
  # expanded map geometry concurrently. Reserve address space generously while
  # keeping the initial physical commit modest; headless modes stay well below
  # this ceiling.
  # Reserve is virtual address space, not committed RAM. Two GiB keeps normal
  # frame allocation pressure away from the hard ceiling while periodic GC is
  # still governed independently below.
  "--heap-reserve", "2g",
  "--heap-commit", "32m",
  "--heap-grow", "16m",
  # Retail rendering retains a large immutable BSP graph plus packed lightmap
  # atlases. Keep the live set comfortably below the release collection
  # horizon so temporary frame data does not trigger a full-graph scan during
  # ordinary play. Loading phases collect explicitly before audio starts;
  # fixed-point audio and precomputed frustum bounds then keep the active-loop
  # allocation rate low enough for this horizon below the 2-GiB reserve.
  "--gc-limit", "1536m"
)
if ($Configuration -ieq "Debug") { $CompilerArguments += "--trace-calls" }
if ($Listings) { $CompilerArguments += @("--asm", "--asm-pe", "--asm-data") }

Write-Host "[MiniQuake2] compiler:        $Compiler"
Write-Host "[MiniQuake2] std import root: $StdImportRoot"
Write-Host "[MiniQuake2] output:          $GameExe"
if ($CompilerIsPython) {
  $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($Compiler) + $CompilerArguments) -Label "MiniLang compilation" -LogPath $CompileLog
} else {
  $null = Invoke-Checked -Executable $Compiler -Arguments $CompilerArguments -Label "MiniLang compilation" -LogPath $CompileLog
}
if (-not (Test-Path -LiteralPath $PartialExe -PathType Leaf)) {
  throw "MiniLang compiler reported success but did not create $PartialExe."
}
Move-Item -Force -LiteralPath $PartialExe -Destination $GameExe

foreach ($RuntimeDll in Get-ChildItem -LiteralPath $Native -Filter "*.dll" -File) {
  Copy-Item -Force -LiteralPath $RuntimeDll.FullName -Destination (Join-Path $Output $RuntimeDll.Name)
}

if (-not $SkipTests) {
  Write-Host "[MiniQuake2] compile contract and integration tests"
  foreach ($TestSource in Get-ChildItem -LiteralPath $Tests -Filter "*.ml" -File | Sort-Object Name) {
    $TestName = [System.IO.Path]::GetFileNameWithoutExtension($TestSource.Name)
    $TestExe = Join-Path $Output ($TestName + ".exe")
    $TestPartial = $TestExe + "." + $PID + ".partial.exe"
    if (Test-Path -LiteralPath $TestPartial -PathType Leaf) { Remove-Item -Force -LiteralPath $TestPartial }
    # These executables also serve as opt-in retail campaign gates. Their
    # no-argument synthetic cases fit the compact test heap, but a caller that
    # supplies a retail root retains several full BSP/collision graphs. Build
    # them with the same memory contract as the product so the durable retail
    # gate tests the engine instead of failing at the harness-only 256-MiB cap.
    $RetailScaleTest = $TestName -in @(
      "baseq2_campaign_retail_smoke_tests",
      "baseq2_entity_parser_lifetime_tests",
      "collision_bsp_product_graph_retention_tests",
      "collision_bsp_retention_tests",
      "network_runtime_campaign_unmasked_tests",
      "runtime_campaign_physical_input_tests",
      "runtime_session_soak_tests"
    )
    $TestHeapReserve = if ($RetailScaleTest) { "2g" } else { "256m" }
    $TestHeapCommit = if ($RetailScaleTest) { "32m" } else { "64m" }
    $TestHeapGrow = if ($RetailScaleTest) { "16m" } else { "4m" }
    $TestGcLimit = if ($RetailScaleTest) { "1536m" } else { "32m" }
    $TestArguments = @(
      $TestSource.FullName, $TestPartial,
      "-I", $Source,
      "-I", $Native,
      "-I", $StdImportRoot,
      "--keep-going", "--max-errors", "50",
      "--heap-reserve", $TestHeapReserve,
      # Several independent native graphs cross the 16-MiB growth guard while
      # constructing their fixtures. Tests are sequential, so a 64-MiB initial
      # commit removes that nondeterministic access violation without raising
      # the 256-MiB address-space reserve.
      "--heap-commit", $TestHeapCommit,
      "--heap-grow", $TestHeapGrow,
      "--gc-limit", $TestGcLimit
    )
    if ($Configuration -ieq "Debug") { $TestArguments += "--trace-calls" }
    if ($CompilerIsPython) {
      $null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($Compiler) + $TestArguments) -Label "$TestName compilation"
    } else {
      $null = Invoke-Checked -Executable $Compiler -Arguments $TestArguments -Label "$TestName compilation"
    }
    if (-not (Test-Path -LiteralPath $TestPartial -PathType Leaf)) { throw "$TestName compiler output missing." }
    Move-Item -Force -LiteralPath $TestPartial -Destination $TestExe
    if (-not $NoRunTests) {
      $null = Invoke-Checked -Executable $TestExe -Label "$TestName execution" -LogPath (Join-Path $Output ($TestName + ".log"))
    }
  }
}

if (-not $SkipTests -and -not $NoRunTests) {
  $Version = Invoke-Checked -Executable $GameExe -Arguments @("--version") -Label "version smoke" -LogPath (Join-Path $Output "smoke-version.log")
  if ($Version.Text -notmatch "MiniQuake2 0\.5\.0-foundation" -or $Version.Text -notmatch "Protocol: 34") {
    throw "Version smoke returned an unexpected compatibility identity."
  }
  $Diagnostics = Invoke-Checked -Executable $GameExe -Arguments @("--diagnostics") -Label "diagnostics smoke" -LogPath (Join-Path $Output "smoke-diagnostics.log")
  if ($Diagnostics.Text -notmatch "MiniQuake2 diagnostics: PASS" -or $Diagnostics.Text -notmatch "retail-data=not-required") {
    throw "Diagnostics smoke returned an unexpected result."
  }
  $Capabilities = Invoke-Checked -Executable $GameExe -Arguments @("--capabilities") -Label "capability smoke" -LogPath (Join-Path $Output "smoke-capabilities.log")
  if ($Capabilities.Text -notmatch "MiniQuake2 capabilities: PASS" -or $Capabilities.Text -notmatch "bytedirs=162") {
    throw "Capability smoke returned an incomplete integrated runtime."
  }
  $Cli = Invoke-Checked -Executable $GameExe -Arguments @("--cli-smoke", "build-script") -Label "CLI smoke" -LogPath (Join-Path $Output "smoke-cli.log")
  if ($Cli.Text -notmatch "MiniQuake2 CLI smoke: PASS" -or $Cli.Text -notmatch "token=build-script") {
    throw "CLI smoke did not preserve argv content."
  }
}

# Re-check build hygiene after compilation. This also proves no reference source
# or proprietary game data was copied as an implicit build step.
$null = Invoke-Checked -Executable $PythonCommand.Path -Arguments @($PythonCommand.Prefix + @($Verifier, "--root", $Root, "--mode", "inventory", "--json", (Join-Path $Output "source-inventory.json"))) -Label "post-build inventory"

Write-Host "MiniQuake2 build: PASS" -ForegroundColor Green
Write-Host "  executable: $GameExe"
