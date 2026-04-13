Import-Module PSScriptAnalyzer

"Performing the static analysis of source code..."
$PSScriptRoot, "src", "test" | Invoke-ScriptAnalyzer -Recurse
Test-ModuleManifest SetupAnt.psd1 | Out-Null
