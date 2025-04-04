import semver from "semver";
import data from "./ReleaseData.json" with {type: "json"};

/**
 * Represents a GitHub release.
 */
export class Release {

	/**
	 * The latest release.
	 */
	static get latest(): Release|null {
		return this.#data.at(0) ?? null;
	}

	/**
	 * The list of all releases.
	 */
	static readonly #data: Release[] = data.map(release => new this(release.version, {archived: release.archived}));

	/**
	 * Value indicating whether this release is archived.
	 */
	archived: boolean;

	/**
	 * The version number.
	 */
	version: string;

	/**
	 * Creates a new release.
	 * @param version The version number.
	 * @param options An object providing values to initialize this instance.
	 */
	constructor(version: string, options: ReleaseOptions = {}) {
		this.version = version;
		this.archived = options.archived ?? false;
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
		const baseUrl = this.archived ? "https://archive.apache.org/dist/ant/binaries/" : "https://downloads.apache.org/ant/binaries/";
		return new URL(`apache-ant-${this.version}-bin.zip`, baseUrl);
	}

	/**
	 * Finds a release that matches the specified version constraint.
	 * @param constraint The version constraint.
	 * @returns The release corresponding to the specified constraint, or `null` if not found.
	 */
	static find(constraint: string): Release|null {
		return this.#data.find(release => semver.satisfies(release.version, constraint)) ?? null;
	}

	/**
	 * Gets the release corresponding to the specified version.
	 * @param version The version number of a release.
	 * @returns The release corresponding to the specified version, or `null` if not found.
	 */
	static get(version: string): Release|null {
		return this.#data.find(release => release.version == version) ?? null;
	}
}

/**
 * Defines the options of a {@link Release} instance.
 */
export type ReleaseOptions = Partial<{

	/**
	 * Value indicating whether this release is archived.
	 */
	archived: boolean;
}>;
