#!/usr/bin/env pwsh
using module ../src/Setup.psm1
# param ([switch] $optionalTasks)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

echo $args
echo $ENV:SETUP_ANT_OPTIONAL_TASKS
echo $ENV:SETUP_ANT_VERSION
echo "OK !"
