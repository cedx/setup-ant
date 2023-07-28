package setup_ant;

import sys.FileSystem;
using Lambda;
using StringTools;
using haxe.io.Path;

/** Tests the features of the `Setup` class. **/
@:asserts final class SetupTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `download()` method. **/
	@:timeout(180_000)
	public function download() {
		new Setup(Release.latest).download().next(path -> {
			//final ivyJar = FileSystem.readDirectory(path).filter(file -> file.startsWith("ivy-") && file.extension() == "jar");
			//asserts.assert(ivyJar.length == 1);
			asserts.assert(FileSystem.exists(Path.join([path, "bin", Sys.systemName() == "Windows" ? "ant.bat" : "ant"])));
			//asserts.assert(FileSystem.exists(Path.join([path, "lib", ivyJar.pop()])));
		}).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `install()` method. **/
	@:timeout(180_000)
	public function install() {
		new Setup(Release.latest).install().next(path -> {
			asserts.assert(Sys.getEnv("ANT_HOME") == path);
			asserts.assert(Sys.getEnv("PATH").contains(path));
		}).handle(asserts.handle);

		return asserts;
	}

	/** Method invoked once before running the first test. **/
	@:setup public function setup() {
		if (Sys.getEnv("RUNNER_TEMP") == null) Sys.putEnv("RUNNER_TEMP", FileSystem.absolutePath("var/tmp"));
		if (Sys.getEnv("RUNNER_TOOL_CACHE") == null) Sys.putEnv("RUNNER_TOOL_CACHE", FileSystem.absolutePath("var/cache"));
		return Noise;
	}
}
