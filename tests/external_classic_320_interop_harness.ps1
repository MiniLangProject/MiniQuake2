# Copyright (c) 2026 Nils Kopal
# SPDX-License-Identifier: Apache-2.0
param(
    [string]$ClassicRoot = 'C:\Program Files (x86)\Steam\steamapps\common\Quake 2',
    [string]$ClassicExecutable = '',
    [string]$MiniQuake2Exe = '',
    [int]$Port = 27931,
    [int]$StartupTimeoutSeconds = 10
)

$ErrorActionPreference = 'Stop'
$workspace = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($MiniQuake2Exe)) {
    $MiniQuake2Exe = Join-Path $workspace 'build\MiniQuake2.exe'
}
if ([string]::IsNullOrWhiteSpace($ClassicExecutable)) {
    $ClassicExecutable = Join-Path $ClassicRoot 'quake2.exe'
}
$classicExe = $ClassicExecutable
$gameDll = Join-Path $ClassicRoot 'baseq2\gamex86.dll'
if (-not (Test-Path -LiteralPath $classicExe -PathType Leaf)) { throw "Classic quake2.exe not found: $classicExe" }
if (-not (Test-Path -LiteralPath $gameDll -PathType Leaf)) { throw "Classic gamex86.dll not found: $gameDll" }
if (-not (Test-Path -LiteralPath $MiniQuake2Exe -PathType Leaf)) { throw "MiniQuake2 executable not found: $MiniQuake2Exe" }
# Find byte pattern count.

function Find-BytePatternCount([byte[]]$Data, [byte[]]$Pattern) {
    $count = 0
    for ($offset = 0; $offset -le $Data.Length - $Pattern.Length; $offset++) {
        $matches = $true
        for ($index = 0; $index -lt $Pattern.Length; $index++) {
            if ($Data[$offset + $index] -ne $Pattern[$index]) { $matches = $false; break }
        }
        if ($matches) { $count++ }
    }
    return $count
}
# Perform query classic status processing.

function Query-ClassicStatus([int]$QueryPort, [int]$TimeoutMilliseconds) {
    $udp = [Net.Sockets.UdpClient]::new()
    try {
        $udp.Client.ReceiveTimeout = $TimeoutMilliseconds
        $payload = [byte[]](255, 255, 255, 255) + [Text.Encoding]::ASCII.GetBytes("status`n")
        [void]$udp.Send($payload, $payload.Length, '127.0.0.1', $QueryPort)
        $remote = [Net.IPEndPoint]::new([Net.IPAddress]::Any, 0)
        $reply = $udp.Receive([ref]$remote)
        return [Text.Encoding]::ASCII.GetString($reply)
    }
    catch {
        return $null
    }
    finally {
        $udp.Dispose()
    }
}
# Stop owned process.

function Stop-OwnedProcess($Process) {
    if ($null -ne $Process -and -not $Process.HasExited) {
        Stop-Process -Id $Process.Id -Force
        Wait-Process -Id $Process.Id -Timeout 3 -ErrorAction SilentlyContinue
    }
}

# Return the currently running Quake II processes without assuming that Steam
# keeps the executable requested by the caller alive.
function Get-QuakeProcesses {
    return @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -match '^quake2.*\.exe$'
    })
}

# Stop only processes that were created after this harness started.  Steam may
# replace classic quake2.exe with the rerelease executable, so the Process
# object returned by Start-Process is not always the process that must be
# cleaned up.
function Stop-OwnedProcessIds([int[]]$ProcessIds) {
    foreach ($processId in $ProcessIds) {
        $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
        if ($null -ne $process) {
            Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
            Wait-Process -Id $processId -Timeout 3 -ErrorAction SilentlyContinue
        }
    }
}

$classicBytes = [IO.File]::ReadAllBytes($classicExe)
$single320 = Find-BytePatternCount $classicBytes ([BitConverter]::GetBytes([single]3.20))
$single319 = Find-BytePatternCount $classicBytes ([BitConverter]::GetBytes([single]3.19))
$classicHash = (Get-FileHash -LiteralPath $classicExe -Algorithm SHA256).Hash
$gameHash = (Get-FileHash -LiteralPath $gameDll -Algorithm SHA256).Hash
Write-Output "EVIDENCE classic-exe-sha256=$classicHash bytes=$($classicBytes.Length) float-3.20=$single320 float-3.19=$single319"
Write-Output "EVIDENCE gamex86-sha256=$gameHash"
if ($single320 -ne 1 -or $single319 -ne 0) {
    Write-Output 'FAIL installed binary does not provide unambiguous embedded 3.20 float evidence'
    exit 1
}

$outputDirectory = Join-Path $workspace 'build\external_classic_320_interop'
New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
$classicServerOut = Join-Path $outputDirectory 'classic-server.stdout.txt'
$classicServerErr = Join-Path $outputDirectory 'classic-server.stderr.txt'
$classicServer = $null
$miniClient = $null
$miniServer = $null
$classicClient = $null
$ownedRedirectProcessIds = @()
$baselineQuakeProcessIds = @(Get-QuakeProcesses | ForEach-Object { [int]$_.ProcessId })

try {
    $classicArguments = @(
        '+set', 'dedicated', '1',
        '+set', 'ip', '127.0.0.1',
        '+set', 'port', "$Port",
        '+set', 'public', '0',
        '+set', 'logfile', '0',
        '+map', 'base1'
    )
    $classicServer = Start-Process -FilePath $classicExe -ArgumentList $classicArguments `
        -WorkingDirectory $ClassicRoot -WindowStyle Hidden `
        -RedirectStandardOutput $classicServerOut -RedirectStandardError $classicServerErr -PassThru
    $classicStatus = $null
    $deadline = (Get-Date).AddSeconds($StartupTimeoutSeconds)
    do {
        Start-Sleep -Milliseconds 250
        $classicStatus = Query-ClassicStatus $Port 250
        $newQuakeProcesses = @(Get-QuakeProcesses | Where-Object {
            $baselineQuakeProcessIds -notcontains [int]$_.ProcessId -and
            ($_.CommandLine -match "(?<!\d)$Port(?!\d)" -or
             [int]$_.ProcessId -eq $classicServer.Id)
        })
        $ownedRedirectProcessIds = @($newQuakeProcesses | Where-Object {
            [int]$_.ProcessId -ne $classicServer.Id
        } | ForEach-Object { [int]$_.ProcessId } | Select-Object -Unique)
    } while ($null -eq $classicStatus -and (Get-Date) -lt $deadline)
    if ($classicServer.HasExited -or $null -eq $classicStatus) {
        $exitText = 'running'
        if ($classicServer.HasExited) { $exitText = "$($classicServer.ExitCode)" }
        $redirectedProcesses = @(Get-QuakeProcesses | Where-Object {
            $ownedRedirectProcessIds -contains [int]$_.ProcessId
        })
        if ($redirectedProcesses.Count -gt 0) {
            $redirectEvidence = @($redirectedProcesses | ForEach-Object {
                "$($_.Name):$($_.ProcessId)"
            }) -join ','
            Write-Output "BLOCKED classic-3.20 launch redirected by distribution client processes=$redirectEvidence"
        }
        Write-Output "BLOCKED classic-3.20-dedicated-start exit=$exitText udp-status=false timeout-seconds=$StartupTimeoutSeconds"
        Write-Output 'BLOCKED MiniQuake2-client -> installed classic server was not executable on this host'
        Write-Output 'BLOCKED installed classic client -> MiniQuake2-server cannot be automated until the same Win32 startup blocker is resolved'
        exit 3
    }
    Write-Output "WIRE classic-status=$($classicStatus.Replace("`r", '').Replace("`n", '|'))"

    $miniClientOut = Join-Path $outputDirectory 'mini-client.stdout.txt'
    $miniClientErr = Join-Path $outputDirectory 'mini-client.stderr.txt'
    $miniClient = Start-Process -FilePath $MiniQuake2Exe `
        -ArgumentList @('--connect', '127.0.0.1', "$Port", '160') `
        -WorkingDirectory $workspace -WindowStyle Hidden `
        -RedirectStandardOutput $miniClientOut -RedirectStandardError $miniClientErr -PassThru
    Wait-Process -Id $miniClient.Id -Timeout 25
    if ($miniClient.ExitCode -ne 0) { throw "MiniQuake2 client failed with exit $($miniClient.ExitCode)" }
    $miniClientText = Get-Content -LiteralPath $miniClientOut -Raw
    if ($miniClientText -notmatch 'state=4' -or $miniClientText -notmatch 'parsed=([1-9][0-9]*)') {
        throw 'MiniQuake2 client did not reach active state against classic server'
    }
    Write-Output 'PASS MiniQuake2-client -> installed classic-3.20-server state=active'
    Stop-OwnedProcess $classicServer

    $miniPort = $Port + 1
    $miniServerOut = Join-Path $outputDirectory 'mini-server.stdout.txt'
    $miniServerErr = Join-Path $outputDirectory 'mini-server.stderr.txt'
    $miniServerArguments = "--dedicated `"$ClassicRoot`" base1 $miniPort 180"
    $miniServer = Start-Process -FilePath $MiniQuake2Exe -ArgumentList $miniServerArguments `
        -WorkingDirectory $workspace -WindowStyle Hidden `
        -RedirectStandardOutput $miniServerOut -RedirectStandardError $miniServerErr -PassThru
    Start-Sleep -Seconds 2
    $miniStatus = Query-ClassicStatus $miniPort 1500
    if ($null -eq $miniStatus) { throw 'MiniQuake2 dedicated server did not answer classic status query' }

    $classicClientOut = Join-Path $outputDirectory 'classic-client.stdout.txt'
    $classicClientErr = Join-Path $outputDirectory 'classic-client.stderr.txt'
    $classicClient = Start-Process -FilePath $classicExe `
        -ArgumentList @('+set', 'logfile', '0', '+connect', "127.0.0.1:$miniPort") `
        -WorkingDirectory $ClassicRoot -WindowStyle Hidden `
        -RedirectStandardOutput $classicClientOut -RedirectStandardError $classicClientErr -PassThru
    Start-Sleep -Seconds 8
    if ($classicClient.HasExited) {
        $newClientProcesses = @(Get-QuakeProcesses | Where-Object {
            $baselineQuakeProcessIds -notcontains [int]$_.ProcessId -and
            [int]$_.ProcessId -ne $classicClient.Id -and
            $_.CommandLine -match "(?<!\d)$miniPort(?!\d)"
        })
        $ownedRedirectProcessIds = @($ownedRedirectProcessIds + @(
            $newClientProcesses | ForEach-Object { [int]$_.ProcessId }
        ) | Select-Object -Unique)
        if ($newClientProcesses.Count -gt 0) {
            throw "Classic client was redirected to a different Quake II process before interoperability observation"
        }
        throw "Classic client exited before interoperability observation, exit=$($classicClient.ExitCode)"
    }
    Stop-OwnedProcess $classicClient
    Wait-Process -Id $miniServer.Id -Timeout 25
    if ($miniServer.ExitCode -ne 0) { throw "MiniQuake2 server failed with exit $($miniServer.ExitCode)" }
    $miniServerText = Get-Content -LiteralPath $miniServerOut -Raw
    if ($miniServerText -notmatch 'received=([1-9][0-9]*)' -or $miniServerText -notmatch 'rejected=0') {
        throw 'MiniQuake2 server did not accept classic client traffic cleanly'
    }
    Write-Output 'PASS installed classic-3.20-client -> MiniQuake2-server received traffic without rejection'
    exit 0
}
finally {
    Stop-OwnedProcess $classicClient
    Stop-OwnedProcess $miniClient
    Stop-OwnedProcess $miniServer
    Stop-OwnedProcess $classicServer
    Stop-OwnedProcessIds $ownedRedirectProcessIds
}
