using namespace System.Diagnostics.CodeAnalysis
using module ../src/Release.psm1
using module ../src/Setup.psm1

<#
.SYNOPSIS
	Tests the features of the `Setup` module.
#>
Describe "Setup" {
	BeforeAll {
		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$latestRelease = [Release]::Latest()

		if (-not (Test-Path Env:GITHUB_ENV)) { $Env:GITHUB_ENV = "var/GitHub-Env.txt" }
		if (-not (Test-Path Env:GITHUB_PATH)) { $Env:GITHUB_PATH = "var/GitHub-Path.txt" }
	}

	Context "Download" {
		It "should properly download and extract Apache Ant" {
			$path = [Setup]::new($latestRelease).Download($true)
			Join-Path $path "bin/$($IsWindows ? "ant.cmd" : "ant")" | Should -Exist
			$jars = Get-ChildItem (Join-Path $path "lib/*.jar")
			$jars.Where{ $_.BaseName.StartsWith("ivy-") } | Should -HaveCount 1
		}
	}

	Context "Install" {
		It "should add the Ant directory to the PATH environment variable" {
			$path = [Setup]::new($latestRelease).Install($false)
			$Env:ANT_HOME | Should -BeExactly $path
			$Env:PATH | Should -BeLikeExactly "*$path*"
		}
	}
}
