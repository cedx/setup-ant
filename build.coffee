{spawnSync} = require "node:child_process"
{readdirSync, readFileSync, rmSync, writeFileSync} = require "node:fs"
{join} = require "node:path"
pkg = require "./package.json"

task "build", "Builds the project.", ->
	npx "coffee", "--compile", "--no-header", "--output", "lib", "src"

task "clean", "Deletes all generated files.", ->
	rmSync "lib", force: yes, recursive: yes
	rmSync join("var", file), recursive: yes for file from readdirSync "var" when file isnt ".gitkeep"

task "dist", "Packages the project.", ->
	invoke script for script from ["clean", "build", "version"]
	npx "rollup", "--config=etc/rollup.js"
	run "git", "update-index", "--chmod=+x", "bin/setup_ant.js"

task "lint", "Performs the static analysis of source code.", ->
	npx "coffeelint", "--file=etc/coffeelint.json", "build.coffee", "src", "test"

task "publish", "Publishes the package.", ->
	invoke "dist"
	run "git", action..., "v#{pkg.version}" for action from [["tag"], ["push", "origin"]]

task "test", "Runs the test suite.", ->
	npx "coffee", "--compile", "--map", "--no-header", "--output", "lib", "src", "test"
	run "node", "--enable-source-maps", "--test"

task "version", "Updates the version number in the sources.", ->
	file = "README.md"
	writeFileSync file, (readFileSync file, "utf8").replace /action\/v\d+(\.\d+){2}/, "action/v#{pkg.version}"

task "watch", "Watches for file changes.", ->
	npx "coffee", "--compile", "--no-header", "--output", "lib", "--watch", "src", "test"

# Executes a command from a local package.
npx = (command, args...) -> run "npm", "exec", "--", command, args...

# Spawns a new process using the specified command.
run = (command, args...) ->
	{status} = spawnSync command, args, shell: on, stdio: "inherit"
	throw Error [command, args...].join " " if status isnt 0
