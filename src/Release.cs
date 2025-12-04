namespace Belin.SetupAnt;

using System.Linq;
using System.Text.RegularExpressions;

/// <summary>
/// Represents an Apache Ant release.
/// </summary>
/// <param name="version">The version number.</param>
public partial class Release(Version version): IEquatable<Release> {

	/// <summary>
	/// The latest release.
	/// </summary>
	public static Release Latest => data.First();

	/// <summary>
	/// Gets the regular expression used to check if a version number represents the latest release.
	/// </summary>
	/// <returns>The regular expression used to check if a version number represents the latest release.</returns>
	[GeneratedRegex(@"^(\*|latest)$", RegexOptions.IgnoreCase)]
	internal static partial Regex LatestReleasePattern();

	/// <summary>
	/// Value indicating whether this release exists.
	/// </summary>
	public bool Exists => data.Any(release => release == this);

	/// <summary>
	/// The download URL.
	/// </summary>
	public Uri Url {
		get {
			var baseUrl = new Uri(this == Latest ? "https://downloads.apache.org/ant/binaries/" : "https://archive.apache.org/dist/ant/binaries/");
			return new(baseUrl, $"apache-ant-{Version}-bin.zip");
		}
	}

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
	/// Determines whether the two specified objects are equal.
	/// </summary>
	/// <param name="object1">The first object.</param>
	/// <param name="object2">The second object.</param>
	/// <returns><see langword="true"/> if <c>object1</c> equals <c>object2</c>, otherwise <see langword="false"/>.</returns>
	public static bool operator ==(Release? object1, Release? object2) =>
		object1 is null ? object2 is null : ReferenceEquals(object1, object2) || object1.Equals(object2);

	/// <summary>
	/// Determines whether the two specified objects are not equal.
	/// </summary>
	/// <param name="object1">The first object.</param>
	/// <param name="object2">The second object.</param>
	/// <returns><see langword="true"/> if <c>object1</c> does not equal <c>object2</c>, otherwise <see langword="false"/>.</returns>
	public static bool operator !=(Release? object1, Release? object2) => !(object1 == object2);

	/// <summary>
	/// Finds a release that matches the specified version constraint.
	/// </summary>
	/// <param name="constraint">The version constraint.</param>
	/// <returns>The release corresponding to the specified constraint, or <see langword="null"/> if not found.</returns>
	/// <exception cref="FormatException">The version constraint is invalid.</exception>
	public static Release? Find(string constraint) {
		var operatorMatch = Regex.Match(constraint, @"^([^\d]+)\d");
		var (op, version) = true switch {
			true when LatestReleasePattern().IsMatch(constraint) => ("=", Latest.Version.ToString()),
			true when operatorMatch.Success => (operatorMatch.Groups[1].Value, Regex.Replace(constraint, @"^[^\d]+", "")),
			true when Regex.IsMatch(constraint, @"^\d") => (">=", constraint),
			_ => throw new FormatException("The version constraint is invalid.")
		};

		var semver = SemanticVersion.Parse(version);
		return data.FirstOrDefault(op switch {
			">" => release => new SemanticVersion(release.Version) > semver,
			">=" => release => new SemanticVersion(release.Version) >= semver,
			"=" => release => new SemanticVersion(release.Version) == semver,
			"<=" => release => new SemanticVersion(release.Version) <= semver,
			"<" => release => new SemanticVersion(release.Version) < semver,
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

	/// <summary>
	/// Determines whether the specified object is equal to this object.
	/// </summary>
	/// <param name="other">An object to compare with this object.</param>
	/// <returns><see langword="true"/> if the specified object is equal to this object, otherwise <see langword="false"/>.</returns>
	public override bool Equals(object? other) => Equals(other as Release);

	/// <summary>
	/// Determines whether the specified object is equal to this object.
	/// </summary>
	/// <param name="other">An object to compare with this object.</param>
	/// <returns><see langword="true"/> if the specified object is equal to this object, otherwise <see langword="false"/>.</returns>
	public bool Equals(Release? other) => other is not null && Version == other.Version;

	/// <summary>
	/// Gets the hash code for this object.
	/// </summary>
	/// <returns>The hash code for this object.</returns>
	public override int GetHashCode() => HashCode.Combine(Version);
}
