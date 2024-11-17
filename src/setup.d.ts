import {Release} from "./release.js";

/**
 * Manages the download and installation of Apache Ant.
 */
export class Setup {

	/**
	 * The release to download and install.
	 */
	release: Release;

	/**
	 * Creates a new setup.
	 * @param release The release to download and install.
	 */
	constructor(release: Release);

	/**
	 * Downloads and extracts the ZIP archive of Apache Ant.
	 * @param options Value indicating whether to fetch the Ant optional tasks.
	 * @returns The path to the extracted directory.
	 */
	download(options?: {optionalTasks?: boolean}): Promise<string>;

	/**
	 * Installs Apache Ant, after downloading it if required.
	 * @param options Value indicating whether to fetch the Ant optional tasks.
	 * @returns The path to the installation directory.
	 */
	install(options?: {optionalTasks?: boolean}): Promise<string>;
}
