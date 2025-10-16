using namespace System.Diagnostics.CodeAnalysis
using module ../src/Release.psm1

<#
.SYNOPSIS
	Tests the features of the `Release` class.
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

	Describe "Exists" {
		It "should return `$true if the release exists" { $existingRelease.Exists() | Should -BeTrue }
		It "should return `$false if the release does not exist" { $nonExistingRelease.Exists() | Should -BeFalse }
	}

	Describe "Url" {
		It "should return the URL of the Ant archive" {
			$existingRelease.Url() | Should -BeExactly "https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.15-bin.zip"
			$nonExistingRelease.Url() | Should -BeExactly "https://archive.apache.org/dist/ant/binaries/apache-ant-666.6.6-bin.zip"
		}
	}

	Describe "Find" {
		It "should return `$null if no release matches the version constraint" {
			[Release]::Find("666.6.6") | Should -Be $null
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

		It "should throw if the version constraint is invalid" {
			{ [Release]::Find("abc") } | Should -Throw
			{ [Release]::Find("?1.10") } | Should -Throw
		}
	}

	Describe "Get" {
		It "should return `$null if no release matches to the version number" { [Release]::Get("666.6.6") | Should -Be $null }
		It "should return the release corresponding to the version number if it exists" { [Release]::Get("1.8.2")?.Version | Should -Be "1.8.2" }
	}

	Describe "Latest" {
		It "should exist" { $latestRelease | Should -Not -Be $null }
	}
}
