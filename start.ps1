#!/usr/bin/env pwsh
using module ./src/Release.psm1
using module ./src/Setup.psm1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$release = [Release]::Find($Env:SETUP_ANT_VERSION)
if (-not $release) { throw "No release matching the version constraint." }

$optionalTasks = $Env:SETUP_ANT_OPTIONAL_TASKS -eq "true"
$installed = $optionalTasks ? "installed with optional tasks" : "installed"

$path = [Setup]::new($release).Install($optionalTasks)
"Apache Ant $($release.Version) successfully $installed in ""$path""."
