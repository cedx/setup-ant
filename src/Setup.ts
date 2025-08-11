import {addPath, exportVariable} from "@actions/core";
import {cacheDir, downloadTool, extractZip, find} from "@actions/tool-cache";
import {execFile} from "node:child_process";
import {readdir} from "node:fs/promises";
import {join} from "node:path";
import {promisify} from "node:util";
import type {Release} from "./Release.js";

/**
 * Spawns a new process using the specified command.
 */
const run = promisify(execFile);

/**
 * Manages the download and installation of Apache Ant.
 */
export class Setup {

	/**
	 * The release to download and install.
	 */
	readonly release: Release;

	/**
	 * Creates a new setup.
	 * @param release The release to download and install.
	 */
	constructor(release: Release) {
		this.release = release;
	}

	/**
	 * Downloads and extracts the ZIP archive of Apache Ant.
	 * @param options Value indicating whether to fetch the Ant optional tasks.
	 * @returns The path to the extracted directory.
	 */
	async download(options: {optionalTasks?: boolean} = {}): Promise<string> {
		const directory = await extractZip(await downloadTool(this.release.url.href));
		const antHome = join(directory, await this.#findSubfolder(directory));
		if (options.optionalTasks) await this.#fetchOptionalTasks(antHome);
		return antHome;
	}

	/**
	 * Installs Apache Ant, after downloading it if required.
	 * @param options Value indicating whether to fetch the Ant optional tasks.
	 * @returns The path to the installation directory.
	 */
	async install(options: {optionalTasks?: boolean} = {}): Promise<string> {
		let antHome = find("ant", this.release.version);
		if (!antHome) antHome = await cacheDir(await this.download(options), "ant", this.release.version);

		addPath(join(antHome, "bin"));
		exportVariable("ANT_HOME", antHome);
		return antHome;
	}

	/**
	 * Fetches the external libraries required by Ant optional tasks.
	 * @param antHome The path to the Ant directory.
	 * @returns Resolves when the optional tasks have been fetched.
	 */
	async #fetchOptionalTasks(antHome: string): Promise<void> {
		const args = ["-jar", "lib/ant-launcher.jar", "-buildfile", "fetch.xml", "-noinput", "-silent", "-Ddest=system"];
		await run("java", args, {cwd: antHome, env: {ANT_HOME: antHome}});
	}

	/**
	 * Determines the name of the single subfolder in the specified directory.
	 * @param directory The directory path.
	 * @returns The name of the single subfolder in the specified directory.
	 * @throws `Error` when the subfolder could not be determined.
	 */
	async #findSubfolder(directory: string): Promise<string> {
		const folders = (await readdir(directory, {withFileTypes: true})).filter(entity => entity.isDirectory());
		switch (folders.length) {
			case 0: throw new Error(`No subfolder found in: ${directory}.`);
			case 1: return folders[0].name;
			default: throw new Error(`Multiple subfolders found in: ${directory}.`);
		}
	}
}
