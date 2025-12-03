@{
	DefaultCommandPrefix = "Ant"
	ModuleVersion = "6.0.0"
	PowerShellVersion = "7.4"
	RootModule = "bin/Belin.SetupAnt.dll"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Set up your GitHub Actions workflow with a specific version of Apache Ant."
	GUID = "30b52520-21cd-44c4-aa11-b1f0dc085686"

	AliasesToExport = @()
	FunctionsToExport = @()
	VariablesToExport = @()

	CmdletsToExport = @(
		"Find-Release"
		"Get-Release"
		"Install-Release"
		"New-Release"
		"Test-Release"
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
