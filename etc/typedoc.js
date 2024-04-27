/**
 * @type {Partial<import("typedoc").TypeDocOptions>}
 */
export default {
	entryPoints: ["../src/index.js"],
	excludePrivate: true,
	gitRevision: "main",
	hideGenerator: true,
	name: "Setup Ant",
	out: "../docs/api",
	readme: "none"
};
