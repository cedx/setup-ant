import {getBooleanInput, getInput, info, setFailed} from "@actions/core";
import process from "node:process"
import {Release} from "./release.js";
import {Setup} from "./setup.js";

/**
 * Application entry point.
 * @returns Resolves when Apache Ant has been installed.
 * @throws `Error` when no release matches the version constraint.
 */
async function main(): Promise<void> {
	process.title = "Setup Ant";

	const version = getInput("version");
	const release = Release.find(!version || version == "latest" ? "*" : version);
	if (!release) throw Error("No release matching the version constraint.");

	const optionalTasks = getBooleanInput("optional-tasks");
	const installed = optionalTasks ? "installed with optional tasks" : "installed";
	const path = await new Setup(release).install({optionalTasks});
	info(`Apache Ant ${release.version} successfully ${installed} in "${path}".`);
}

// Start the application.
main().catch(error => setFailed(error instanceof Error ? error : String(error)));
