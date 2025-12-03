using namespace System.Diagnostics.CodeAnalysis
Import-Module "$PSScriptRoot/../../SetupAnt.psd1"

[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
$existingRelease = New-AntRelease "1.10.15"

[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
$latestRelease = Get-AntRelease "Latest"

[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
$nonExistingRelease = New-AntRelease "666.6.6"
