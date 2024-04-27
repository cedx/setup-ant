import semver from "semver";
import data from "./data.js";

/**
 * Represents an Apache Ant release.
 */
export class Release {

	/**
	 * The base URL of the releases.
	 * @type {URL}
	 * @readonly
	 */
	static #baseUrl = new URL("https://dlcdn.apache.org/ant/binaries/");

	/**
	 * The list of all releases.
	 * @type {Release[]}
	 * @readonly
	 */
	static #data = data.map(release => new this(release.version));

	/**
	 * The version number.
	 * @type {string}
	 * @readonly
	 */
	version;

	/**
	 * Creates a new release.
	 * @param {string} version The version number.
	 */
	constructor(version) {
		this.version = version;
	}

	/**
	 * The latest release.
	 * @type {Release}
	 */
	static get latest() {
		return this.#data[0];
	}

	/**
	 * Value indicating whether this release exists.
	 * @type {boolean}
	 */
	get exists() {
		return Release.#data.some(release => release.version == this.version);
	}

	/**
	 * The download URL.
	 * @type {URL}
	 */
	get url() {
		return new URL(`apache-ant-${this.version}-bin.zip`, Release.#baseUrl);
	}

	/**
	 * Finds a release that matches the specified version constraint.
	 * @param {string} constraint The version constraint.
	 * @returns {Release|null} The release corresponding to the specified constraint.
	 */
	static find(constraint) {
		return this.#data.find(release => semver.satisfies(release.version, constraint)) ?? null;
	}

	/**
	 * Gets the release corresponding to the specified version.
	 * @param {string} version The version number of a release.
	 * @returns {Release|null} The release corresponding to the specified version.
	 */
	static get(version) {
		return this.#data.find(release => release.version == version) ?? null;
	}
}
