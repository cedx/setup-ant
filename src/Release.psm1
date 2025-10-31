<#
.SYNOPSIS
	Represents an Apache Ant release.
#>
class Release {

	<#
	.SYNOPSIS
		The list of all releases.
	#>
	hidden static [Release[]] $Data

	<#
	.SYNOPSIS
		The version number.
	#>
	[ValidateNotNull()] [semver] $Version

	<#
	.SYNOPSIS
		Creates a new release.
	.PARAMETER Version
		The version number.
	#>
	Release([string] $Version) {
		$this.Version = $Version
	}

	<#
	.SYNOPSIS
		Initializes the class.
	#>
	static Release() {
		[Release]::Data = (Import-PowerShellDataFile "$PSScriptRoot/Data.psd1").Releases.ForEach{ [Release] $_ }
	}

	<#
	.SYNOPSIS
		Gets a value indicating whether this release exists.
	.OUTPUTS
		`$true` if this release exists, otherwise `$false`.
	#>
	[bool] Exists() {
		return $null -ne [Release]::Get($this.Version)
	}

	<#
	.SYNOPSIS
		Gets the download URL.
	.OUTPUTS
		The download URL.
	#>
	[uri] GetUrl() {
		return "https://archive.apache.org/dist/ant/binaries/apache-ant-$($this.Version)-bin.zip"
	}

	<#
	.SYNOPSIS
		Finds a release that matches the specified version constraint.
	.PARAMETER Constraint
		The version constraint.
	.OUTPUTS
		The release corresponding to the specified constraint, or `$null` if not found.
	#>
	static [Release] Find([string] $Constraint) {
		$operator, $semver = switch -Regex ($Constraint) {
			"^(\*|latest)$" { "=", [Release]::Latest().Version; break }
			"^([^\d]+)\d" { $Matches[1], [semver] ($Constraint -replace "^([^\d]+)", ""); break }
			"^\d" { ">=", [semver] $Constraint; break }
			default { throw [FormatException] "The version constraint is invalid." }
		}

		$predicate = switch ($operator) {
			">=" { { $_.Version -ge $semver }; break }
			">" { { $_.Version -gt $semver }; break }
			"<=" { { $_.Version -le $semver }; break }
			"<" { { $_.Version -lt $semver }; break }
			"=" { { $_.Version -eq $semver }; break }
			default { throw [FormatException] "The version constraint is invalid." }
		}

		return [Release]::Data.Where($predicate)[0]
	}

	<#
	.SYNOPSIS
		Gets the release corresponding to the specified version.
	.PARAMETER Version
		The version number of a release.
	.OUTPUTS
		The release corresponding to the specified version, or `$null` if not found.
	#>
	static [Release] Get([string] $Version) {
		return [Release]::Data.Where({ $_.Version -eq $Version }, "First")[0]
	}

	<#
	.SYNOPSIS
		Gets the latest release.
	.OUTPUTS
		The latest release, or `$null` if not found.
	#>
	static [Release] Latest() {
		return [Release]::Data[0]
	}
}
