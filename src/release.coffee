import semver from "semver"
import data from "./data.js"

# Represents a GitHub release.
export class Release

	# The base URL of the releases.
	@baseUrl = new URL "https://dlcdn.apache.org/ant/binaries/"

	# The list of all releases.
	@data = data.map (release) -> new Release release.version

	# Creates a new release.
	constructor: (version) ->

		# The version number.
		@version = version

	# The latest release.
	Object.defineProperty @, "latest",
		get: -> @data.at(0) or null

	# Value indicating whether this release exists.
	Object.defineProperty @::, "exists",
		get: -> Release.data.some (release) => release.version is @version

	# The download URL.
	Object.defineProperty @::, "url",
		get: -> new URL "apache-ant-#{@version}-bin.zip", Release.baseUrl

	# Finds a release that matches the specified version constraint.
	@find: (constraint) -> (@data.find (release) -> semver.satisfies release.version, constraint) or null

	# Gets the release corresponding to the specified version.
	@get: (version) -> (@data.find (release) -> release.version is version) or null
