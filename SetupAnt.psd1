@{
	ModuleVersion = "5.1.0"
	RootModule = "src/Main.psm1"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	DefaultCommandPrefix = "Ant"
	Description = "Set up your GitHub Actions workflow with a specific version of Apache Ant."
	GUID = "30b52520-21cd-44c4-aa11-b1f0dc085686"
	PowerShellVersion = "7.4"

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
		"src/Release.psm1"
		"src/Setup.psm1"
	)

	PrivateData = @{
		PSData = @{
			LicenseUri = "https://raw.githubusercontent.com/cedx/setup-ant/main/License.md"
			ProjectUri = "https://github.com/cedx/setup-ant"
			ReleaseNotes = "https://github.com/cedx/setup-ant/releases"
			Tags = "actions", "ant", "ci", "ivy", "java"
		}
	}
}
