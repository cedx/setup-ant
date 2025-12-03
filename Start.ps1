#!/usr/bin/env pwsh
Import-Module "$PSScriptRoot/SetupAnt.psd1"

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version Latest
if (-not (Test-Path Env:SETUP_ANT_VERSION)) { $Env:SETUP_ANT_VERSION = "Latest" }

$optionalTasks = $Env:SETUP_ANT_OPTIONAL_TASKS -eq "true"
$path = Install-Release $Env:SETUP_ANT_VERSION -OptionalTasks:$optionalTasks
$installed = $optionalTasks ? "installed with optional tasks" : "installed"
"Apache Ant $($release.Version) successfully $installed in ""$path""."
