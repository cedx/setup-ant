import {doesNotReject, equal, ok} from "node:assert/strict"
import {access, readdir} from "node:fs/promises"
import {join, resolve} from "node:path"
import {env, platform} from "node:process"
import {describe, it} from "node:test"
import {Release, Setup} from "@cedx/setup-ant"

# Tests the features of the `Setup` class.
describe "Setup", ->
	env.RUNNER_TEMP ?= resolve "var/tmp"
	env.RUNNER_TOOL_CACHE ?= resolve "var/cache"

	describe "download()", ->
		it "should properly download and extract Apache Ant", ->
			path = await new Setup(Release.latest).download optionalTasks: yes
			await doesNotReject access join path, "bin", if platform is "win32" then "ant.cmd" else "ant"

			jars = (await readdir join path, "lib").filter (file) -> file.endsWith ".jar"
			equal jars.filter((file) -> file.startsWith "ivy-").length, 1

	describe "install()", ->
		it "should add the Ant directory to the PATH environment variable", ->
			path = await new Setup(Release.get "1.7.1").install optionalTasks: no
			equal env.ANT_HOME, path
			ok env.PATH.includes path
