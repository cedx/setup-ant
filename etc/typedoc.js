/**
 * @type {Partial<import("typedoc").TypeDocOptions>}
 */
export default {
	entryPoints: ["../src/index.ts"],
	excludePrivate: true,
	gitRevision: "main",
	hideGenerator: true,
	name: "Setup Ant",
	out: "../docs/api",
	readme: "none"
};
