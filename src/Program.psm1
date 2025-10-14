<#
.SYNOPSIS
	Application entry point.
#>
try {

	$version = getInput("version")
	$release = [Release]::Find(!version || version == "latest" ? "*" : version)
	if (-not $release) { throw new Error("No release matching the version constraint.") }

	$optionalTasks = getBooleanInput("optional-tasks")
	$installed = optionalTasks ? "installed with optional tasks" : "installed"
	$path = new Setup(release).install({optionalTasks})
	info(`Apache Ant ${release.version} successfully ${installed} in "${path}".`)
}
catch {

}
// Start the application.
main().catch((error: unknown) => setFailed(error instanceof Error ? error : String(error)))
