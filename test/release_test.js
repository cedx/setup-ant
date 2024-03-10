import {equal, ok} from "node:assert/strict";
import {describe, it} from "node:test";
import {Release} from "@cedx/setup-ant";

/**
 * Tests the features of the {@link Release} class.
 */
describe("Release", () => {
	const existingRelease = new Release("1.10.14");
	const nonExistentRelease = new Release("666.6.6");

	describe("exists", () => {
		it("should return `false` if the release does not exist", () => ok(!nonExistentRelease.exists));
		it("should return `true` if the release exists", () => ok(existingRelease.exists));
	});

	describe("latest", () => {
		it("should exist", () => ok(Release.latest.exists));
	});

	describe("url", () => {
		it("should return the URL of the Ant archive", () => {
			equal(existingRelease.url.href, "https://dlcdn.apache.org/ant/binaries/apache-ant-1.10.14-bin.zip");
			equal(nonExistentRelease.url.href, "https://dlcdn.apache.org/ant/binaries/apache-ant-666.6.6-bin.zip");
		});
	});

	describe("find()", () => {
		it("should return `null` if no release matches the version constraint", () =>
			ok(!Release.find("666.6.6")));

		it("should return the release corresponding to the version constraint if it exists", () => {
			equal(Release.find("*"), Release.latest);
			equal(Release.find("1.x"), Release.latest);
			equal(Release.find("=1.9.16")?.version, "1.9.16");
			equal(Release.find(">=1.0.0 <1.10.0")?.version, "1.9.16");
		});
	});

	describe("get()", () => {
		it("should return `null` if no release matches to the version number", () => ok(!Release.get("666.6.6")));
		it("should return the release corresponding to the version number if it exists", () => equal(Release.get("1.10.14")?.version, "1.10.14"));
	});
});
