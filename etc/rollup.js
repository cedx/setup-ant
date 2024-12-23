import commonjs from "@rollup/plugin-commonjs";
import resolve from "@rollup/plugin-node-resolve";
import terser from "@rollup/plugin-terser";

/**
 * The build options.
 * @type {import("rollup").RollupOptions}
 */
export default {
	context: "this",
	input: "lib/cli.js",
	output: {
		banner: "#!/usr/bin/env node",
		file: "bin/setup_ant.js"
	},
	plugins: [
		resolve({preferBuiltins: true}),
		commonjs({sourceMap: false}),
		terser({compress: true, format: {comments: false}, mangle: true})
	]
};
