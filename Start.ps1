#!/usr/bin/env pwsh
using namespace Belin.SetupAnt

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version Latest

Add-Type -Path "$PSScriptRoot/bin/Belin.SetupAnt.dll"
if (-not (Test-Path Env:SETUP_ANT_VERSION)) { $Env:SETUP_ANT_VERSION = "Latest" }

$release = [Release]::Find($Env:SETUP_ANT_VERSION)
if (-not $release) { throw "No release matches the specified version constraint." }

$optionalTasks = $Env:SETUP_ANT_OPTIONAL_TASKS -eq "true"
$path = [Setup]::new($release).Install($optionalTasks)

$installed = $optionalTasks ? "installed with optional tasks" : "installed"
"Apache Ant $($release.Version) successfully $installed in ""$path""."
