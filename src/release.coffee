import semver from "semver"
import data from "./data.js"

# Represents a GitHub release.
export class Release

	# The list of all releases.
	@data = data.map (release) -> new Release release.version, release.archived

	# Creates a new release.
	constructor: (version, archived = no) ->

		# Value indicating whether this release is archived.
		@archived = archived

		# The version number.
		@version = version

	# The latest release.
	Object.defineProperty @, "latest", get: -> @data.at(0) or null

	# Value indicating whether this release exists.
	Object.defineProperty @::, "exists", get: -> Release.data.some (release) => release.version is @version

	# The download URL.
	Object.defineProperty @::, "url", get: ->
		baseUrl = if @archived then "https://archive.apache.org/dist/ant/binaries/" else "https://downloads.apache.org/ant/binaries/"
		new URL "apache-ant-#{@version}-bin.zip", baseUrl

	# Finds a release that matches the specified version constraint.
	@find: (constraint) -> (@data.find (release) -> semver.satisfies release.version, constraint) or null

	# Gets the release corresponding to the specified version.
	@get: (version) -> (@data.find (release) -> release.version is version) or null
