import {getBooleanInput, getInput, info, setFailed} from "@actions/core"
import process from "node:process"
import {Release} from "./release.js"
import {Setup} from "./setup.js"

try
	process.title = "Setup Ant"

	version = getInput "version"
	release = Release.find if not version or version is "latest" then "*" else version
	throw Error "No release matching the version constraint." unless release

	optionalTasks = getBooleanInput "optional-tasks"
	installed = if optionalTasks then "installed with optional tasks" else "installed"
	path = await new Setup(release).install {optionalTasks}
	info "Apache Ant #{release.version} successfully #{installed} in \"#{path}\"."

catch error
	setFailed if error instanceof Error then error else String error
