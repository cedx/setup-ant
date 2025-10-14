Write-Output "Running the test suite..."
pwsh -Command {
	Import-Module Pester -Scope Local
	Invoke-Pester test
}
