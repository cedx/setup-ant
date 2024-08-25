package setup_ant;

import coconut.data.List;
import coconut.data.Model;
import haxe.Resource;
import tink.Json;
import tink.Url;
import tink.semver.Constraint;
import tink.semver.Version;

/** Represents a GitHub release. **/
@:jsonParse(json -> new setup_ant.Release(json))
class Release implements Model {

	/** The latest release. **/
	public static var latest(get, never): Release;
		static function get_latest() return data.first().sure();

	/** The base URL of the releases. **/
	static final baseUrl: Url = "https://dlcdn.apache.org/ant/binaries/";

	/** The list of all releases. **/
	static final data: List<Release> = (Json.parse(Resource.getString("releases.json")): Array<Release>);

	/** Value indicating whether this release exists. **/
	@:computed var exists: Bool = data.exists(release -> release.version == version);

	/** The download URL. **/
	@:computed var url: Url = baseUrl.resolve('apache-ant-$version-bin.zip');

	/** The version number. **/
	@:constant var version: String = @byDefault "0.0.0";

	/** Finds a release that matches the specified version constraint. **/
	public static function find(constraint: Constraint): Option<Release>
		return data.first(release -> constraint.matches(release.version));

	/** Gets the release corresponding to the specified version. **/
	public static function get(version: Version): Option<Release>
		return data.first(release -> release.version == version);
}
