/** Packages the project. **/
function main() {
	for (script in ["Clean", "Build", "Version"]) Sys.command('lix $script');
	Sys.command("npx rollup --config=etc/rollup.js");
	Sys.command("git update-index --chmod=+x bin/setup_ant.js");
}
