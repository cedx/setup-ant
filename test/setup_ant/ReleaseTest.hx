package setup_ant;

import setup_ant.Release.ReleaseAsset as Asset;
using AssertionTools;

/** Tests the features of the `Release` class. **/
@:asserts final class ReleaseTest {

	/** A release that exists. **/
	public static final existingRelease = new Release({version: "1.10.13"});

	/** A release that doesn't exist. **/
	public static final nonExistentRelease = new Release({version: "666.6.6"});

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `exists` property. **/
	@:variant(setup_ant.ReleaseTest.existingRelease, true)
	@:variant(setup_ant.ReleaseTest.nonExistentRelease, false)
	public function exists(input: Release, output: Bool)
		return assert(input.exists == output);

	/** Tests the `latest` property. **/
	public function latest() {
		asserts.doesNotThrow(() -> Release.latest);
		return asserts.done();
	}

	/** Tests the `url` property. **/
	@:variant(setup_ant.ReleaseTest.existingRelease, "https://dlcdn.apache.org/ant/binaries/apache-ant-1.10.13-bin.zip")
	@:variant(setup_ant.ReleaseTest.nonExistentRelease, "https://dlcdn.apache.org/ant/binaries/apache-ant-666.6.6-bin.zip")
	public function url(input: Release, output: String)
		return assert(input.url == output);

	/** Tests the `find()` method. **/
	@:variant("*", Some(setup_ant.Release.latest.version))
	@:variant("1.x", Some(setup_ant.Release.latest.version))
	@:variant("=1.9.16", Some("1.9.16"))
	@:variant(">=1.0.0 <1.10.0", Some("1.9.16"))
	@:variant("666.6.6", None)
	public function find(input: String, output: Option<String>) return switch Release.find(input) {
		case None: assert(output == None);
		case Some(release): assert(output.equals(release.version));
	}

	/** Tests the `get()` method. **/
	@:variant("1.10.13", Some("1.10.13"))
	@:variant("666.6.6", None)
	public function get(input: String, output: Option<String>) return switch Release.get(input) {
		case None: assert(output == None);
		case Some(release): assert(output.equals(release.version));
	}
}
