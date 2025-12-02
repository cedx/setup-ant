namespace Belin.SetupAnt;

using System.Text.RegularExpressions;

/// <summary>
/// Represents an Apache Ant release.
/// </summary>
/// <param name="version">The version number.</param>
public partial class Release(Version version) {

	/// <summary>
	/// The latest release.
	/// </summary>
	public static Release Latest => data.First();

	/// <summary>
	/// The download URL.
	/// </summary>
	public Uri Url => new($"https://archive.apache.org/dist/ant/binaries/apache-ant-{Version}-bin.zip");

	/// <summary>
	/// The version number.
	/// </summary>
	public Version Version => version;

	/// <summary>
	/// Creates a new release.
	/// </summary>
	/// <param name="version">The version number.</param>
	public Release(string version): this(Version.Parse(version)) {}

	/// <summary>
	/// Finds a release that matches the specified version constraint.
	/// </summary>
	/// <param name="constraint">The version constraint.</param>
	/// <returns>The release corresponding to the specified constraint, or <see langword="null"/> if not found.</returns>
	/// <exception cref="FormatException">The version constraint is invalid.</exception>
	public static Release? Find(string constraint) {
		var opPattern = new Regex(@"^([^\d]+)\d");
		var (op, version) = true switch {
			true when Regex.IsMatch(constraint, @"^(\*|latest)$", RegexOptions.IgnoreCase) => ("=", Latest.Version),
			true when opPattern.IsMatch(constraint) => (opPattern.Match(constraint).Groups[1].Value, Version.Parse(Regex.Replace(constraint, @"^[^\d]+", ""))),
			true when Regex.IsMatch(constraint, @"^\d") => ("=", Version.Parse(constraint)),
			_ => throw new FormatException("The version constraint is invalid.")
		};

		return data.FirstOrDefault(op switch {
			">" => release => release.Version > version,
			">=" => release => release.Version >= version,
			"=" => release => release.Version == version,
			"<=" => release => release.Version <= version,
			"<" => release => release.Version < version,
			_ => throw new FormatException("The version constraint is invalid.")
		});
	}

	/// <summary>
	/// Gets the release corresponding to the specified version.
	/// </summary>
	/// <param name="version">The version number of a release.</param>
	/// <returns>The release corresponding to the specified version, or <see langword="null"/> if not found.</returns>
	public static Release? Get(string version) => Get(Version.Parse(version));

	/// <summary>
	/// Gets the release corresponding to the specified version.
	/// </summary>
	/// <param name="version">The version number of a release.</param>
	/// <returns>The release corresponding to the specified version, or <see langword="null"/> if not found.</returns>
	public static Release? Get(Version version) => data.SingleOrDefault(release => release.Version == version);
}
