import {doesNotReject, equal, ok} from "node:assert/strict";
import {access, readdir} from "node:fs/promises";
import {extname, join, resolve} from "node:path";
import {env, platform} from "node:process";
import {describe, it} from "node:test";
import {Release, Setup} from "@cedx/setup-ant";

/**
 * Tests the features of the {@link Setup} class.
 */
describe("Setup", () => {
	env.RUNNER_TEMP ||= resolve("var/tmp");
	env.RUNNER_TOOL_CACHE ||= resolve("var/cache");

	describe("download()", () => {
		it("should properly download and extract Apache Ant", async () => {
			const path = await new Setup(Release.latest).download({optionalTasks: true});
			await doesNotReject(access(join(path, "bin", platform == "win32" ? "ant.bat" : "ant")));

			const jars = (await readdir(join(path, "lib"))).filter(file => extname(file) == ".jar");
			equal(jars.filter(file => file.startsWith("ivy-")).length, 1);
		});
	});

	describe("install()", () => {
		it("should add the Ant directory to the PATH environment variable", async () => {
			const path = await new Setup(Release.latest).install({optionalTasks: false});
			equal(env.ANT_HOME, path);
			ok(env.PATH?.includes(path));
		});
	});
});
