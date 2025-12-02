Import-Module "$PSScriptRoot/../../SetupAnt.psd1"

$existingRelease = New-AntRelease "1.10.15"
$latestRelease = Get-AntRelease "Latest"
$nonExistingRelease = New-AntRelease "666.6.6"
