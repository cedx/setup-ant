import {addPath, exportVariable} from "@actions/core"
import {cacheDir, downloadTool, extractZip, find} from "@actions/tool-cache"
import {execFile} from "node:child_process"
import {readdir} from "node:fs/promises"
import {join} from "node:path"
import {promisify} from "node:util"

# Manages the download and installation of Apache Ant.
export class Setup

	# Creates a new setup.
	constructor: (release) ->

		# The release to download and install.
		@release = release

	# Downloads and extracts the ZIP archive of Apache Ant.
	# Returns the path to the extracted directory.
	download: (options = {}) ->
		directory = await extractZip await downloadTool @release.url.href
		antHome = join directory, await @_findSubfolder directory
		await @_fetchOptionalTasks antHome if options.optionalTasks
		antHome

	# Installs Apache Ant, after downloading it if required.
	# Returns the path to the installation directory.
	install: (options = {}) ->
		antHome = if path = find("ant", @release.version) then path else await cacheDir (await @download options), "ant", @release.version
		addPath join antHome, "bin"
		exportVariable "ANT_HOME", antHome
		antHome

	# Fetches the external libraries required by Ant optional tasks.
	_fetchOptionalTasks: (antHome) ->
		run = promisify execFile
		run "java", ["-jar", "lib/ant-launcher.jar", "-buildfile", "fetch.xml", "-noinput", "-silent", "-Ddest=system"],
			cwd: antHome
			env: {ANT_HOME: antHome}

	# Determines the name of the single subfolder in the specified directory.
	_findSubfolder: (directory) ->
		folders = (await readdir directory, withFileTypes: yes).filter (entity) -> entity.isDirectory()
		switch folders.length
			when 0 then throw Error "No subfolder found in: #{directory}."
			when 1 then folders[0].name
			else throw Error "Multiple subfolders found in: #{directory}."
