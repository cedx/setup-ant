using namespace System.Diagnostics.CodeAnalysis
using module ./Release.psm1
using module ./Setup.psm1

<#
.SYNOPSIS
	Finds a release that matches the specified version constraint.
.PARAMETER Constraint
	The version constraint.
.INPUTS
	A string that contains a version constraint.
.OUTPUTS
	The release corresponding to the specified constraint, or `$null` if not found.
#>
function Find-Release {
	[OutputType([Release])]
	param (
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[ValidateNotNullOrWhiteSpace()]
		[string] $Constraint
	)

	process {
		[Release]::Find($Constraint)
	}
}

<#
.SYNOPSIS
	Gets the release corresponding to the specified version.
.PARAMETER Version
	The version number. Use `*` or `Latest` to get the latest release.
.INPUTS
	A string that contains a version number.
.OUTPUTS
	The release corresponding to the specified version, or `$null` if not found.
#>
function Get-Release {
	[OutputType([Release])]
	param (
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[ValidateNotNullOrWhiteSpace()]
		[string] $Version
	)

	process {
		$Version -in @("*", "Latest") ? [Release]::Latest() : [Release]::Get($Version)
	}
}

<#
.SYNOPSIS
	Installs Apache Ant, after downloading it.
.PARAMETER Version
	The version number of the release to be installed.
.PARAMETER InputObject
	The instance of the release to be installed.
.PARAMETER OptionalTasks
	Value indicating whether to fetch the Ant optional tasks.
.INPUTS
	[string] A string that contains a version number.
.INPUTS
	[Release] An instance of the `Release` class to be installed.
.OUTPUTS
	The path to the installation directory.
#>
function Install-Release {
	[CmdletBinding(DefaultParameterSetName = "Version")]
	[OutputType([string])]
	param (
		[Parameter(Mandatory, ParameterSetName = "Version", Position = 0, ValueFromPipeline)]
		[ValidateNotNullOrWhiteSpace()]
		[string] $Version,

		[Parameter(Mandatory, ParameterSetName = "InputObject", Position = 0, ValueFromPipeline)]
		[ValidateNotNull()]
		[Release] $InputObject,

		[Parameter()]
		[switch] $OptionalTasks
	)

	process {
		$release = $InputObject ? $InputObject : [Release]::new($Version)
		[Setup]::new($release).Install($OptionalTasks)
	}
}

<#
.SYNOPSIS
	Creates a new release.
.PARAMETER Version
	The version number.
.INPUTS
	A string that contains a version number.
.OUTPUTS
	The newly created release.
#>
function New-Release {
	[OutputType([Release])]
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[ValidateNotNullOrWhiteSpace()]
		[string] $Version
	)

	process {
		[Release]::new($Version)
	}
}

<#
.SYNOPSIS
	Gets a value indicating whether a release with the specified version exists.
.PARAMETER Version
	The version number of the release to be tested.
.PARAMETER InputObject
	The instance of the release to be tested.
.INPUTS
	[string] A string that contains a version number.
.INPUTS
	[Release] An instance of the `Release` class to be tested.
.OUTPUTS
	`$true` if a release with the specified version exists, otherwise `$false`.
#>
function Test-Release {
	[CmdletBinding(DefaultParameterSetName = "Version")]
	[OutputType([bool])]
	param (
		[Parameter(Mandatory, ParameterSetName = "Version", Position = 0, ValueFromPipeline)]
		[ValidateNotNullOrWhiteSpace()]
		[string] $Version,

		[Parameter(Mandatory, ParameterSetName = "InputObject", Position = 0, ValueFromPipeline)]
		[ValidateNotNull()]
		[Release] $InputObject
	)

	process {
		$release = $InputObject ? $InputObject : [Release]::new($Version)
		$release.Exists()
	}
}
