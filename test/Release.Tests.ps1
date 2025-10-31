using namespace System.Diagnostics.CodeAnalysis
using module ../src/Release.psm1

<#
.SYNOPSIS
	Tests the features of the `Release` module.
#>
Describe "Release" {
	BeforeAll {
		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$existingRelease = [Release] "1.10.15"

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$latestRelease = [Release]::Latest()

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$nonExistingRelease = [Release] "666.6.6"
	}

	Context "Exists" {
		It "should return `$true if the release exists" {
			$existingRelease.Exists() | Should -BeTrue
		}

		It "should return `$false if the release does not exist" {
			$nonExistingRelease.Exists() | Should -BeFalse
		}
	}

	Context "GetUrl" {
		It "should return the URL of the Ant archive" {
			$existingRelease.GetUrl() | Should -BeExactly "https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.15-bin.zip"
			$nonExistingRelease.GetUrl() | Should -BeExactly "https://archive.apache.org/dist/ant/binaries/apache-ant-666.6.6-bin.zip"
		}
	}

	Context "Find" {
		It "should return `$null if no release matches the version constraint" {
			[Release]::Find($nonExistingRelease.Version) | Should -Be $null
		}

		It "should return the release corresponding to the version constraint if it exists" {
			[Release]::Find("latest") | Should -Be $latestRelease
			[Release]::Find("*") | Should -Be $latestRelease
			[Release]::Find("1") | Should -Be $latestRelease
			[Release]::Find("2") | Should -Be $null
			[Release]::Find(">1.10.15")?.Version | Should -Be $null
			[Release]::Find("=1.8.2")?.Version | Should -Be "1.8.2"
			[Release]::Find("<1.10")?.Version | Should -Be "1.9.16"
			[Release]::Find("<=1.10")?.Version | Should -Be "1.10.0"
		}

		It "should throw if the version constraint is invalid" -TestCases @{ Version = "abc" }, @{ Version = "?1.10" } {
			{ [Release]::Find($version) } | Should -Throw
		}
	}

	Context "Get" {
		It "should return `$null if no release matches to the version number" {
			[Release]::Get($nonExistingRelease.Version) | Should -Be $null
		}

		It "should return the release corresponding to the version number if it exists" {
			[Release]::Get("1.8.2")?.Version | Should -Be "1.8.2"
		}
	}

	Context "Latest" {
		It "should exist" {
			$latestRelease | Should -Not -Be $null
		}
	}
}
