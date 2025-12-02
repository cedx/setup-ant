using namespace System.Diagnostics.CodeAnalysis

<#
.SYNOPSIS
	Tests the features of the `Main` module.
#>
Describe "Main" {
	BeforeAll {
		Import-Module "$PSScriptRoot/../SetupAnt.psd1"

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$existingRelease = New-AntRelease "1.10.15"

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$latestRelease = Get-AntRelease "Latest"

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$nonExistingRelease = New-AntRelease "666.6.6"
	}

	Context "Find-Release" {
		It "should return `$null if no release matches the version constraint" {
			Find-AntRelease $nonExistingRelease.Version | Should -Be $null
		}

		It "should return the release corresponding to the version constraint if it exists" {
			Find-AntRelease "latest" | Should -Be $latestRelease
			Find-AntRelease "*" | Should -Be $latestRelease
			Find-AntRelease "1" | Should -Be $latestRelease
			Find-AntRelease "2" | Should -Be $null
			(Find-AntRelease ">1.10.15")?.Version | Should -Be $null
			(Find-AntRelease "=1.8.2")?.Version | Should -Be "1.8.2"
			(Find-AntRelease "<1.10")?.Version | Should -Be "1.9.16"
			(Find-AntRelease "<=1.10")?.Version | Should -Be "1.10.0"
		}

		It "should throw if the version constraint is invalid" -TestCases @{ Version = "abc" }, @{ Version = "?1.10" } {
			{ Find-AntRelease $version } | Should -Throw
		}
	}

	Context "Get-Release" {
		It "should return `$null if no release matches to the version number" {
			Get-AntRelease $nonExistingRelease.Version | Should -Be $null
		}

		It "should return the release corresponding to the version number if it exists" {
			(Get-AntRelease "1.8.2")?.Version | Should -Be "1.8.2"
		}
	}

	Context "Test-Release" {
		It "should return `$true for the latest release" {
			Test-AntRelease $latestRelease.Version | Should -BeTrue
			$latestRelease | Test-AntRelease | Should -BeTrue
		}

		It "should return `$true if the release exists" {
			Test-AntRelease $existingRelease.Version | Should -BeTrue
			$existingRelease | Test-AntRelease | Should -BeTrue
		}

		It "should return `$false if the release does not exist" {
			Test-AntRelease $nonExistingRelease.Version | Should -BeFalse
			$nonExistingRelease | Test-AntRelease | Should -BeFalse
		}
	}
}
