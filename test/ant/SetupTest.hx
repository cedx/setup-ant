package ant;

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
		new Setup(Release.latest).download(true).next(path -> {
			final jars = FileSystem.readDirectory(Path.join([path, "lib"])).filter(file -> file.extension() == "jar");
			asserts.assert(FileSystem.exists(Path.join([path, "bin", Sys.systemName() == "Windows" ? "ant.cmd" : "ant"])));
			asserts.assert(jars.filter(file -> file.startsWith("ivy-")).length == 1);
		}).handle(asserts.handle);

		return asserts;
	}

	/** Tests the `install()` method. **/
	@:timeout(180_000)
	public function install() {
		new Setup(Release.latest).install(false).next(path -> {
			asserts.assert(Sys.getEnv("ANT_HOME") == path);
			asserts.assert(Sys.getEnv("PATH").contains(path));
		}).handle(asserts.handle);

		return asserts;
	}

	/** Method invoked once before running the first test. **/
	@:setup public function setup(): Promise<Noise> {
		if (Sys.getEnv("RUNNER_TEMP") == null) Sys.putEnv("RUNNER_TEMP", FileSystem.absolutePath("var/tmp"));
		if (Sys.getEnv("RUNNER_TOOL_CACHE") == null) Sys.putEnv("RUNNER_TOOL_CACHE", FileSystem.absolutePath("var/cache"));
		return Noise;
	}
}
