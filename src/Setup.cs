namespace Belin.SetupAnt;

using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Threading;

/// <summary>
/// Manages the download and installation of Apache Ant.
/// </summary>
/// <param name="release">The release to download and install.</param>
public class Setup(Release release) {

	/// <summary>
	/// The release to download and install.
	/// </summary>
	public Release Release => release;

	/// <summary>
	/// Downloads and extracts the ZIP archive of Apache Ant.
	/// </summary>
	/// <param name="optionalTasks">Value indicating whether to fetch the Ant optional tasks.</param>
	/// <returns>The path to the extracted directory.</returns>
	public string Download(bool optionalTasks = false) => DownloadAsync(optionalTasks, CancellationToken.None).GetAwaiter().GetResult();

	/// <summary>
	/// Downloads and extracts the ZIP archive of Apache Ant.
	/// </summary>
	/// <param name="optionalTasks">Value indicating whether to fetch the Ant optional tasks.</param>
	/// <param name="cancellationToken">The token to cancel the operation.</param>
	/// <returns>The path to the extracted directory.</returns>
	public async Task<string> DownloadAsync(bool optionalTasks = false, CancellationToken cancellationToken = default) {
		using var httpClient = new HttpClient();
		var version = GetType().Assembly.GetName().Version!;
		httpClient.DefaultRequestHeaders.Add("User-Agent", $".NET/{Environment.Version.ToString(3)} | SetupAnt/{version.ToString(3)}");

		var bytes = await httpClient.GetByteArrayAsync(Release.Url, cancellationToken);
		var file = Path.GetTempFileName();
		await File.WriteAllBytesAsync(file, bytes, cancellationToken);

		var directory = Path.Join(Path.GetTempPath(), Guid.NewGuid().ToString());
		// TODO (.NET 10) await ZipFile.ExtractToDirectoryAsync(file, directory, cancellationToken);
		ZipFile.ExtractToDirectory(file, directory);

		var antHome = Path.Join(directory, Path.GetFileName(Directory.EnumerateDirectories(directory).Single()));
		if (optionalTasks) await FetchOptionalTasks(antHome);
		return antHome;
	}

	/// <summary>
	/// Installs Apache Ant, after downloading it.
	/// </summary>
	/// <param name="optionalTasks">Value indicating whether to fetch the Ant optional tasks.</param>
	/// <returns>The path to the installation directory.</returns>
	public string Install(bool optionalTasks = false) => InstallAsync(optionalTasks, CancellationToken.None).GetAwaiter().GetResult();

	/// <summary>
	/// Installs Apache Ant, after downloading it.
	/// </summary>
	/// <param name="optionalTasks">Value indicating whether to fetch the Ant optional tasks.</param>
	/// <param name="cancellationToken">The token to cancel the operation.</param>
	/// <returns>The path to the installation directory.</returns>
	public async Task<string> InstallAsync(bool optionalTasks = false, CancellationToken cancellationToken = default) {
		var antHome = await DownloadAsync(optionalTasks, cancellationToken);

		var binFolder = Path.Join(antHome, "bin");
		Environment.SetEnvironmentVariable("PATH", $"{Environment.GetEnvironmentVariable("PATH")}{Path.PathSeparator}{binFolder}");
		await File.AppendAllTextAsync(Environment.GetEnvironmentVariable("GITHUB_PATH")!, binFolder, cancellationToken);

		Environment.SetEnvironmentVariable("ANT_HOME", antHome);
		await File.AppendAllTextAsync(Environment.GetEnvironmentVariable("GITHUB_ENV")!, $"ANT_HOME={antHome}", cancellationToken);
		return antHome;
	}

	/// <summary>
	/// Fetches the external libraries required by Ant optional tasks.
	/// </summary>
	/// <param name="antHome">The path to the Ant directory.</param>
	/// <returns>Completes when the external libraries have been fetched.</returns>
	/// <exception cref="ApplicationFailedException">An error occurred while executing a native command.</exception>
	private static async Task FetchOptionalTasks(string antHome) {
		var arguments = new[] {
			"-jar", "lib/ant-launcher.jar",
			"-buildfile", "fetch.xml",
			"-noinput",
			"-silent",
			"-Ddest=system"
		};

		var startInfo = new ProcessStartInfo("java", arguments) {
			CreateNoWindow = true,
			EnvironmentVariables = { ["ANT_HOME"] = antHome },
			WorkingDirectory = antHome
		};

		using var process = Process.Start(startInfo) ?? throw new ApplicationFailedException(startInfo.FileName);
		await process.WaitForExitAsync();
		if (process.ExitCode != 0) throw new ApplicationFailedException(startInfo.FileName);
	}
}
