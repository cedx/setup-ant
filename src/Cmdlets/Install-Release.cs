namespace Belin.SetupAnt.Cmdlets;

/// <summary>
/// Installs Apache Ant, after downloading it.
/// </summary>
[Cmdlet(VerbsLifecycle.Install, "Release")]
[OutputType(typeof(string))]
public class InstallReleaseCommand: PSCmdlet {

	/// <summary>
	/// The instance of the release to be installed.
	/// </summary>
	[Parameter(Mandatory = true, ParameterSetName = "InputObject", ValueFromPipeline = true)]
	public required Release InputObject { get; set; }

	/// <summary>
	/// Value indicating whether to fetch the Ant optional tasks.
	/// </summary>
	[Parameter]
	public SwitchParameter OptionalTasks { get; set; }

	/// <summary>
	/// The version number of the release to be installed.
	/// </summary>
	[Parameter(Mandatory = true, ParameterSetName = "Version", Position = 0, ValueFromPipeline = true)]
	public required Version Version { get; set; }

	/// <summary>
	/// Performs execution of this command.
	/// </summary>
	protected override void ProcessRecord() {
		var release = ParameterSetName == "InputObject" ? InputObject : new Release(Version);
		// TODO WriteObject(new Setup(release).Install(OptionalTasks));
	}
}
