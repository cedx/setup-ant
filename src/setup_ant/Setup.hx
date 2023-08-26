package setup_ant;

import js.actions.Core;
import js.actions.ToolCache;
import sys.FileSystem;
using Lambda;
using StringTools;
using haxe.io.Path;

/** Manages the download and installation of Apache Ant. **/
class Setup {

	/** The release to download and install. **/
	public final release: Release;

	/** Creates a new setup. **/
	public function new(release: Release) this.release = release;

	/**
		Downloads and extracts the ZIP archive of Apache Ant.
		Returns the path to the extracted directory.
	**/
	public function download(optionalTasks = false) return ToolCache.downloadTool(release.url).toPromise()
		.next(file -> ToolCache.extractZip(file))
		.next(path -> findSubfolder(path).next(name -> normalizeSeparator(Path.join([path, name]))))
		.next(antHome -> optionalTasks ? fetchOptionalTasks(antHome).next(_ -> antHome) : Promise.resolve(antHome));

	/**
		Installs Apache Ant, after downloading it if required.
		Returns the path to the install directory.
	**/
	public function install(optionalTasks = false) {
		final directory = ToolCache.find("ant", release.version);
		final promise = directory.length > 0
			? Promise.resolve(directory)
			: download(optionalTasks).next(path -> ToolCache.cacheDir(path, "ant", release.version));

		return promise.next(path -> {
			final normalizedPath = normalizeSeparator(path);
			Core.addPath(normalizeSeparator(Path.join([path, "bin"])));
			Core.exportVariable("ANT_HOME", normalizedPath);
			normalizedPath;
		});
	}

	/** Fetches the external libraries required by Ant optional tasks. **/
	function fetchOptionalTasks(antHome: String) {
		final workingDirectory = Sys.getCwd();
		Sys.putEnv("ANT_HOME", antHome);
		Sys.setCwd(antHome);
		Sys.command("ant -buildfile fetch.xml -noinput -silent -Ddest=system");
		Sys.setCwd(workingDirectory);
		return Promise.NOISE;
	}

	/** Determines the name of the single subfolder in the specified `directory`. **/
	function findSubfolder(directory: String) {
		final folders = FileSystem.readDirectory(directory).filter(name -> FileSystem.isDirectory(Path.join([directory, name])));
		return switch folders.length {
			case 0: Failure(new Error(NotFound, 'No subfolder found in: $directory.'));
			case 1: Success(folders.pop());
			default: Failure(new Error(Conflict, 'Multiple subfolders found in: $directory.'));
		}
	}

	/** Normalizes the segment separators of the given `path` using the platform-specific separator. **/
	function normalizeSeparator(path: String)
		return Sys.systemName() == "Windows" ? path.replace("/", "\\") : path;
}
