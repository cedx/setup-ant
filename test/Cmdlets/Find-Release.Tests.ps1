<#
.SYNOPSIS
	Tests the features of the `Find-Release` cmdlet.
#>
Describe "Find-Release" {
	BeforeAll {
		. "$PSScriptRoot/BeforeAll.ps1"
	}

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
