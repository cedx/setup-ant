import semver from "semver";
import data from "./data.js";

/**
 * Represents an Apache Ant release.
 */
export class Release {

	/**
	 * The base URL of the releases.
	 */
	static readonly #baseUrl = new URL("https://dlcdn.apache.org/ant/binaries/");

	/**
	 * The list of all releases.
	 */
	static readonly #data: Release[] = data.map(release => new this(release.version));

	/**
	 * The version number.
	 */
	readonly version: string;

	/**
	 * Creates a new release.
	 * @param version The version number.
	 */
	constructor(version: string) {
		this.version = version;
	}

	/**
	 * The latest release.
	 */
	static get latest(): Release {
		return this.#data[0];
	}

	/**
	 * Value indicating whether this release exists.
	 */
	get exists(): boolean {
		return Release.#data.some(release => release.version == this.version);
	}

	/**
	 * The download URL.
	 */
	get url(): URL {
		return new URL(`apache-ant-${this.version}-bin.zip`, Release.#baseUrl);
	}

	/**
	 * Finds a release that matches the specified version constraint.
	 * @param constraint The version constraint.
	 * @returns The release corresponding to the specified constraint.
	 */
	static find(constraint: string): Release|null {
		return this.#data.find(release => semver.satisfies(release.version, constraint)) ?? null;
	}

	/**
	 * Gets the release corresponding to the specified version.
	 * @param version The version number of a release.
	 * @returns The release corresponding to the specified version.
	 */
	static get(version: string): Release|null {
		return this.#data.find(release => release.version == version) ?? null;
	}
}
