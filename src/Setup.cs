namespace Belin.SetupAnt;

/// <summary>
/// Manages the download and installation of Apache Ant.
/// </summary>
/// <param name="release">The release to download and install.</param>
public class Setup(Release release) {

	/// <summary>
	/// Downloads and extracts the ZIP archive of Apache Ant.
	/// </summary>
	/// <param name="optionalTasks">Value indicating whether to fetch the Ant optional tasks.</param>
	/// <returns>The path to the extracted directory.</returns>
	public string Download(bool optionalTasks = false) {
		return "TODO";
	}

	/// <summary>
	/// Installs Apache Ant, after downloading it.
	/// </summary>
	/// <param name="optionalTasks">Value indicating whether to fetch the Ant optional tasks.</param>
	/// <returns>The path to the installation directory.</returns>
	public string Install(bool optionalTasks = false) {
		return "TODO";
	}
}
