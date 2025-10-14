#!/usr/bin/env pwsh
# using module ./src/Release.psm1
# using module ./src/Setup.psm1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

echo "- args"
echo $args
echo "- env:SETUP_ANT_OPTIONAL_TASKS"
echo $ENV:SETUP_ANT_OPTIONAL_TASKS
echo "- env:SETUP_ANT_VERSION"
echo $ENV:SETUP_ANT_VERSION
echo - "OK !"
