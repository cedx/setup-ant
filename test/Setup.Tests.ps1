using module ../src/Release.psm1
using module ../src/Setup.psm1

<#
.SYNOPSIS
	Tests the features of the {@link Setup} class.
#>
Describe "Setup" {
	BeforeAll {
		$latestRelease = [Release]::Latest()
		$Env:GITHUB_ENV = "var/GitHub-Env.txt"
		$Env:GITHUB_PATH = "var/GitHub-Path.txt"
	}

	Describe "Download()" {
		It "should properly download and extract Apache Ant" {
			$path = [Setup]::new($latestRelease).Download($true)
			Join-Path $path "bin/$($IsWindows ? "ant.cmd" : "ant")" | Should -Exist
			$jars = Get-ChildItem (Join-Path $path "lib/*.jar")
			$jars.Where{ $_.BaseName.StartsWith("ivy-") } | Should -HaveCount 1
		}
	}

	Describe "Install()" {
		It "should add the Ant directory to the PATH environment variable" {
			$path = [Setup]::new($latestRelease).Install($false)
			$Env:ANT_HOME | Should -BeExactly $path
			$Env:PATH | Should -BeLikeExactly "*$path*"
		}
	}
}
