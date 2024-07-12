import {getBooleanInput, getInput, info, setFailed} from "@actions/core";
import {Release} from "./release.js";
import {Setup} from "./setup.js";

/**
 * Application entry point.
 * @returns Resolves when Apache Ant has been installed.
 */
async function main(): Promise<void> {
	const version = getInput("version");
	const release = Release.find(!version || version == "latest" ? "*" : version);
	if (!release) throw Error("No release matching the version constraint.");

	const optionalTasks = getBooleanInput("optional-tasks");
	const path = await new Setup(release).install({optionalTasks});
	const installed = optionalTasks ? "installed with optional tasks" : "installed";
	info(`Apache Ant ${release.version} successfully ${installed} in "${path}".`);
}

// Start the application.
main().catch((error: unknown) => setFailed(error instanceof Error ? error : String(error)));
