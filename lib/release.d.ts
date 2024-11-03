/**
 * Represents a GitHub release.
 */
export class Release {

	/**
	 * The base URL of the releases.
	 */
	static baseUrl: URL;

	/**
	 * The list of all releases.
	 */
	static data: Array<Release>;

	/**
	 * The latest release.
	 */
	static readonly latest: Release|null;

	/**
	 * Value indicating whether this release exists.
	 */
	readonly exists: boolean;

	/**
	 * The download URL.
	 */
	readonly url: URL;

	/**
	 * The version number.
	 */
	version: string;

	/**
	 * Creates a new release.
	 * @param version The version number.
	 */
	constructor(version: string);

	/**
	 * Finds a release that matches the specified version constraint.
	 * @param constraint The version constraint.
	 * @returns The release corresponding to the specified constraint, or `null` if not found.
	 */
	static find(constraint: string): Release|null;

	/**
	 * Gets the release corresponding to the specified version.
	 * @param version The version number of a release.
	 * @returns The release corresponding to the specified version, or `null` if not found.
	 */
	static get(version: string): Release|null;
}
