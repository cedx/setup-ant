#!/usr/bin/env pwsh
using module ./src/Release.psm1
using module ./src/Setup.psm1

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version Latest

# TODO Import-Module "$PSScriptRoot/SetupAnt.psd1"
if (-not (Test-Path Env:SETUP_ANT_VERSION)) { $Env:SETUP_ANT_VERSION = "Latest" }

$release = [Release]::Find($Env:SETUP_ANT_VERSION)
if (-not $release) { throw "No release matches the specified version constraint." }

$optionalTasks = $Env:SETUP_ANT_OPTIONAL_TASKS -eq "true"
$path = [Setup]::new($release).Install($optionalTasks)

$installed = $optionalTasks ? "installed with optional tasks" : "installed"
"Apache Ant $($release.Version) successfully $installed in ""$path""."
