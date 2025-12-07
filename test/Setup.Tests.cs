namespace Belin.SetupAnt;

/// <summary>
/// Tests the features of the <see cref="Setup"/> class.
/// </summary>
/// <param name="testContext">The test context.</param>
[TestClass]
public sealed class SetupTests(TestContext testContext) {

	[ClassInitialize]
	public static void ClassInitialize(TestContext testContext) {
		var baseDir = Path.Join(AppContext.BaseDirectory, "../var");
		if (string.IsNullOrEmpty(Environment.GetEnvironmentVariable("GITHUB_ENV"))) Environment.SetEnvironmentVariable("GITHUB_ENV", Path.Join(baseDir, "GitHub-Env.txt"));
		if (string.IsNullOrEmpty(Environment.GetEnvironmentVariable("GITHUB_PATH"))) Environment.SetEnvironmentVariable("GITHUB_PATH", Path.Join(baseDir, "GitHub-Path.txt"));
	}

	[TestMethod]
	public async Task Download() {
		var path = await new Setup(Release.Latest).DownloadAsync(optionalTasks: true, testContext.CancellationToken);
		IsTrue(File.Exists(Path.Join(path, "bin", OperatingSystem.IsWindows() ? "ant.cmd" : "ant")));

		var jars = Directory.EnumerateFiles(Path.Join(path, "lib"), "*.jar");
		HasCount(1, jars.Where(jar => Path.GetFileName(jar).StartsWith("ivy-")));
	}

	[TestMethod]
	public async Task Install() {
		var path = await new Setup(Release.Latest).InstallAsync(optionalTasks: false, testContext.CancellationToken);
		AreEqual(path, Environment.GetEnvironmentVariable("ANT_HOME"));
		Contains(path, Environment.GetEnvironmentVariable("PATH")!);
	}
}
