"Updating the version number in the sources..."
$version = (Import-PowerShellDataFile "SetupAnt.psd1").ModuleVersion
(Get-Content "ReadMe.md") -replace "action\/v\d+(\.\d+){2}", "action/v$version" | Out-File "ReadMe.md"
