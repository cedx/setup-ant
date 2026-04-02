#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version Latest

Import-Module "$PSScriptRoot/SetupAnt.psd1"
if (-not (Test-Path Env:SETUP_ANT_VERSION)) { $Env:SETUP_ANT_VERSION = "Latest" }

$optionalTasks = $Env:SETUP_ANT_OPTIONAL_TASKS -eq "true"
$path = Install-AntRelease $Env:SETUP_ANT_VERSION -OptionalTasks:$optionalTasks

$installed = $optionalTasks ? "installed with optional tasks" : "installed"
"Apache Ant $($release.Version) successfully $installed in ""$path""."
