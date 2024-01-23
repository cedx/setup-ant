import {getBooleanInput, getInput, info, setFailed} from "@actions/core";
import {Release, Setup} from "./index.js";

// Start the application.
try {
	const version = getInput("version");
	const release = Release.find(!version || version == "latest" ? "*" : version);
	if (!release) throw Error("No release matching the version constraint.");

	const optionalTasks = getBooleanInput("optional-tasks");
	const path = await new Setup(release).install(optionalTasks);
	const installed = optionalTasks ? "installed with optional tasks" : "installed";
	info(`Apache Ant ${release.version} successfully ${installed} in "${path}".`);
}
catch (error) {
	setFailed(error instanceof Error ? error : String(error));
}
