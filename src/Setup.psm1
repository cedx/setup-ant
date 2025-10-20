using namespace System.Diagnostics.CodeAnalysis
using namespace System.IO
using module ./Release.psm1

<#
.SYNOPSIS
	Manages the download and installation of Apache Ant.
#>
class Setup {

	<#
	.SYNOPSIS
		The release to download and install.
	#>
	hidden [ValidateNotNull()] [Release] $Release

	<#
	.SYNOPSIS
		Creates a new setup.
	.PARAMETER Release
		The release to download and install.
	#>
	Setup([Release] $Release) {
		$this.Release = $Release
	}

	<#
	.SYNOPSIS
		Downloads and extracts the ZIP archive of Apache Ant.
	.PARAMETER OptionalTasks
		Value indicating whether to fetch the Ant optional tasks.
	.OUTPUTS
		The path to the extracted directory.
	#>
	[string] Download([bool] $OptionalTasks) {
		$file = New-TemporaryFile
		Invoke-WebRequest $this.Release.Url() -OutFile $file

		$directory = Join-Path ([Path]::GetTempPath()) (New-Guid)
		Expand-Archive $file $directory -Force

		$antHome = Join-Path $directory $this.FindSubfolder($directory)
		if ($OptionalTasks) { $this.FetchOptionalTasks($antHome) }
		return $antHome
	}

	<#
	.SYNOPSIS
		Installs Apache Ant, after downloading it.
	.PARAMETER OptionalTasks
		Value indicating whether to fetch the Ant optional tasks.
	.OUTPUTS
		The path to the installation directory.
	#>
	[string] Install([bool] $OptionalTasks) {
		$antHome = $this.Download($OptionalTasks)

		$binFolder = Join-Path $antHome "bin"
		$Env:PATH += "$([Path]::PathSeparator)$binFolder"
		Add-Content $Env:GITHUB_PATH $binFolder

		$Env:ANT_HOME = $antHome
		Add-Content $Env:GITHUB_ENV "ANT_HOME=$Env:ANT_HOME"
		return $antHome
	}

	<#
	.SYNOPSIS
		Fetches the external libraries required by Ant optional tasks.
	.PARAMETER AntHome
		The path to the Ant directory.
	#>
	hidden [void] FetchOptionalTasks([string] $AntHome) {
		$options = "-jar lib/ant-launcher.jar -buildfile fetch.xml -noinput -silent -Ddest=system"
		Start-Process java $options -Environment @{ ANT_HOME = $AntHome } -NoNewWindow -Wait -WorkingDirectory $AntHome
	}

	<#
	.SYNOPSIS
		Determines the name of the single subfolder in the specified directory.
	.PARAMETER Directory
		The directory path.
	.OUTPUTS
		The name of the single subfolder in the specified directory.
	#>
	[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
	hidden [string] FindSubfolder([string] $Directory) {
		$folders = Get-ChildItem $Directory -Directory
		return $discard = switch ($folders.Count) {
			0 { throw "No subfolder found in: $Directory." }
			1 { $folders[0].BaseName; break }
			default { throw "Multiple subfolders found in: $Directory." }
		}
	}
}
