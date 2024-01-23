import {exec} from "node:child_process";
import {readdir} from "node:fs/promises";
import {join} from "node:path";
import {promisify} from "node:util";
import {addPath, exportVariable} from "@actions/core";
import {cacheDir, downloadTool, extractZip, find} from "@actions/tool-cache";
import type {Release} from "./release.js";

/**
 * Manages the download and installation of Apache Ant.
 */
class Setup {

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
	 * @param optionalTasks Value indicating whether to fetch the Ant optional tasks.
	 * @returns The path to the extracted directory.
	 */
	async download(optionalTasks = false): Promise<string> {
		const path = await extractZip(await downloadTool(this.release.url.href));
		const antHome = join(path, await this.#findSubfolder(path));
		if (optionalTasks) await this.fetchOptionalTasks(antHome);
		return antHome;
	}
	
	/**
	 * Installs Apache Ant, after downloading it if required.
	 * @param optionalTasks Value indicating whether to fetch the Ant optional tasks.
	 * @returns The path to the installation directory.
	 */
	async install(optionalTasks = false): Promise<string> {
		let antHome = find("ant", this.release.version);
		if (!antHome) {
			const path = await this.download(optionalTasks);
			antHome = await cacheDir(path, "ant", this.release.version);
		}

		addPath(join(antHome, "bin"));
		exportVariable("ANT_HOME", antHome);
		return antHome;
	}

	/**
	 * Fetches the external libraries required by Ant optional tasks.
	 * @param antHome The path to the Ant directory.
	 * @returns Resolves when the optional tasks have been fetched.
	 */
	fetchOptionalTasks(antHome: string): Promise<unknown> {
		return promisify(exec)("ant -buildfile fetch.xml -noinput -silent -Ddest=system", {cwd: antHome, env: {ANT_HOME: antHome}});
	}

	/**
	 * Determines the name of the single subfolder in the specified directory.
	 * @param directory The directory path.
	 * @returns The name of the single subfolder in the specified directory.
	 */
	async #findSubfolder(directory: string): Promise<string> {
		const folders = (await readdir(directory, {withFileTypes: true})).filter(entity => entity.isDirectory());
		switch (folders.length) {
			case 0: throw Error(`No subfolder found in: ${directory}.`);
			case 1: return folders[0].name;
			default: throw Error(`Multiple subfolders found in: ${directory}.`);
		}
	}
}
