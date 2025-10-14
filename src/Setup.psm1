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
	hidden [Release] $Release

	<#
	.SYNOPSIS
		Creates a new setup.
	.PARAMETER $release
		The release to download and install.
	#>
	Setup([Release] $release) {
		$this.Release = $release
	}

	<#
	.SYNOPSIS
		Downloads and extracts the ZIP archive of Apache Ant.
	.PARAMETER $optionalTasks
		Value indicating whether to fetch the Ant optional tasks.
	.OUTPUTS
		The path to the extracted directory.
	#>
	[string] Download([bool] $optionalTasks) {
		$file = New-TemporaryFile
		Invoke-WebRequest $this.Release.Url() -OutFile $file

		$directory = Join-Path ([Path]::GetTempPath()) (New-Guid)
		Expand-Archive $file $directory -Force

		$antHome = Join-Path $directory $this.FindSubfolder($directory)
		if ($optionalTasks) { $this.FetchOptionalTasks($antHome) }
		return $antHome
	}

	<#
	.SYNOPSIS
		Installs Apache Ant, after downloading it if required.
	.PARAMETER $optionalTasks
		Value indicating whether to fetch the Ant optional tasks.
	.OUTPUTS
		The path to the installation directory.
	#>
	[string] Install([bool] $optionalTasks) {
		$antHome = $this.Download($optionalTasks)
		$Env:ANT_HOME = $antHome
		Add-Content $Env:GITHUB_ENV "ANT_HOME=$antHome"

		$binFolder = Join-Path $antHome "bin"
		$Env:PATH += "$([Path]::PathSeparator)$binFolder"
		Add-Content $Env:GITHUB_PATH $binFolder

		return $antHome
	}

	<#
	.SYNOPSIS
		Fetches the external libraries required by Ant optional tasks.
	.PARAMETER $antHome
		The path to the Ant directory.
	#>
	hidden [void] FetchOptionalTasks([string] $antHome) {
		$options = "-jar lib/ant-launcher.jar -buildfile fetch.xml -noinput -silent -Ddest=system"
		Start-Process java $options -Environment @{ ANT_HOME = $antHome } -NoNewWindow -Wait -WorkingDirectory $antHome
	}

	<#
	.SYNOPSIS
		Determines the name of the single subfolder in the specified directory.
	.PARAMETER $directory
		The directory path.
	.OUTPUTS
		The name of the single subfolder in the specified directory.
	#>
	hidden [string] FindSubfolder([string] $directory) {
		$folders = Get-ChildItem $directory -Directory
		return $discard = switch ($folders.Length) {
			0 { throw "No subfolder found in: $directory." }
			1 { $folders[0].Name } # TODO BaseName ?
			default { throw "Multiple subfolders found in: $directory." }
		}
	}
}
