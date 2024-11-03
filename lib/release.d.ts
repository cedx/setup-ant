/**
 * Represents a GitHub release.
 */
export declare class Release {

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
	static get latest(): Release|null;

	/**
	 * Value indicating whether this release exists.
	 */
	get exists(): boolean;

	/**
	 * The download URL.
	 */
	get url(): URL;

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
	 * @returns The release corresponding to the specified constraint.
	 */
	static find(constraint: string): Release|null;

	/**
	 * Gets the release corresponding to the specified version.
	 * @param version The version number of a release.
	 * @returns The release corresponding to the specified version.
	 */
	static get(version: string): Release|null;
}