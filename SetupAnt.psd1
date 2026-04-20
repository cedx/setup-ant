@{
	DefaultCommandPrefix = "Ant"
	ModuleVersion = "6.2.0"
	PowerShellVersion = "7.4"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Set up your GitHub Actions workflow with a specific version of Apache Ant."
	GUID = "30b52520-21cd-44c4-aa11-b1f0dc085686"

	AliasesToExport = @()
	CmdletsToExport = @()
	VariablesToExport = @()

	FunctionsToExport = @(
		"Find-Release"
		"Get-Release"
		"Install-Release"
		"New-Release"
		"Test-Release"
	)

	NestedModules = @(
		"src/Cmdlets/Find-Release.psm1"
		"src/Cmdlets/Get-Release.psm1"
		"src/Cmdlets/Install-Release.psm1"
		"src/Cmdlets/New-Release.psm1"
		"src/Cmdlets/Test-Release.psm1"
	)

	PrivateData = @{
		PSData = @{
			LicenseUri = "https://github.com/cedx/setup-ant/blob/main/License.md"
			ProjectUri = "https://github.com/cedx/setup-ant"
			ReleaseNotes = "https://github.com/cedx/setup-ant/releases"
			Tags = "actions", "ant", "ci", "ivy", "java"
		}
	}
}
