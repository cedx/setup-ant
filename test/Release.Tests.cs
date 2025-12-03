namespace Belin.SetupAnt;

/// <summary>
/// Tests the features of the <see cref="Release"/> class.
/// </summary>
/// <param name="testContext">The test context.</param>
[TestClass]
public sealed class ReleaseTests {

	/// <summary>
	/// A release that exists.
	/// </summary>
	private readonly Release existingRelease = new("1.10.15");

	/// <summary>
	/// A release that does not exist.
	/// </summary>
	private readonly Release nonExistingRelease = new("666.6.6");

	[TestMethod]
	public void Exists() {
		IsTrue(existingRelease.Exists);
		IsFalse(nonExistingRelease.Exists);
	}

	[TestMethod]
	public void Url() {
		AreEqual(new Uri("https://downloads.apache.org/ant/binaries/apache-ant-1.10.15-bin.zip"), existingRelease.Url);
		AreEqual(new Uri("https://archive.apache.org/dist/ant/binaries/apache-ant-666.6.6-bin.zip"), nonExistingRelease.Url);
	}

	[TestMethod]
	public void Find() {
		IsNull(Release.Find(nonExistingRelease.Version.ToString()));
		IsNull(Release.Find("2"));
		IsNull(Release.Find(">1.10.15"));

		AreEqual(Release.Latest, Release.Find("latest"));
		AreEqual(Release.Latest, Release.Find("*"));
		AreEqual(Release.Latest, Release.Find("1"));

		AreEqual(new Release("1.8.2"), Release.Find("=1.8.2"));
		AreEqual(new Release("1.9.16"), Release.Find("<1.10"));
		AreEqual(new Release("1.10.0"), Release.Find("<=1.10"));

		Throws<FormatException>(() => Release.Find("abc"));
		Throws<FormatException>(() => Release.Find("?1.10"));
	}

	[TestMethod]
	public void Get() {
		IsNull(Release.Get(nonExistingRelease.Version));
		AreEqual(Version.Parse("1.8.2"), Release.Get("1.8.2")?.Version);
	}
}
