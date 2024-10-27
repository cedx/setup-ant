"use strict";
const resolve = require("@rollup/plugin-node-resolve");
const terser = require("@rollup/plugin-terser");

/** @type {import("rollup").RollupOptions} */
module.exports = {
	input: "bin/setup_ant.js",
	output: {file: "bin/setup_ant.js", format: "cjs"},
	plugins: [resolve(), terser()]
};
