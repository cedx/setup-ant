import {addPath, exportVariable} from "@actions/core";
import {cacheDir, downloadTool, extractZip, find} from "@actions/tool-cache";
import {exec} from "node:child_process";
import {readdir} from "node:fs/promises";
import {join} from "node:path";
import {promisify} from "node:util";
import type {Release} from "./release.js";

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
	async download(options: Partial<{optionalTasks: boolean}> = {}): Promise<string> {
		const path = await extractZip(await downloadTool(this.release.url.href));
		const directory = join(path, await this.#findSubfolder(path));
		if (options.optionalTasks) await this.#fetchOptionalTasks(directory);
		return directory;
	}

	/**
	 * Installs Apache Ant, after downloading it if required.
	 * @param options Value indicating whether to fetch the Ant optional tasks.
	 * @returns The path to the installation directory.
	 */
	async install(options: Partial<{optionalTasks: boolean}> = {}): Promise<string> {
		let directory = find("ant", this.release.version);
		if (!directory) {
			const path = await this.download(options);
			directory = await cacheDir(path, "ant", this.release.version);
		}

		addPath(join(directory, "bin"));
		exportVariable("ANT_HOME", directory);
		return directory;
	}

	/**
	 * Fetches the external libraries required by Ant optional tasks.
	 * @param antHome The path to the Ant directory.
	 * @returns Resolves when the optional tasks have been fetched.
	 */
	#fetchOptionalTasks(antHome: string): Promise<unknown> {
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
