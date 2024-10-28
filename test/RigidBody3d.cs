using Godot;
using System;
using System.IO;
using System.Text;


public partial class RigidBody3d : RigidBody3D
{
	// Cameras
	private Camera3D thirdPersonCamera;
	private Camera3D firstPersonCamera;
	private bool isThirdPersonActive = true;  // Initially start with the third-person camera

	// Movement and rotation speed settings
	private float movementSpeed = 20.0f;
	private float rotationSpeed = 30.0f;
	private float maxTiltAngle = Mathf.Pi / 4;

	// label information
	private Label _infoLabel;
	
	// Writing path
	private const string LOG_FILE_PATH = "user://tank_log.csv";
	private StreamWriter logWriter;
	
	public override void _Ready()
	{
		// Find the cameras in the scene
		thirdPersonCamera = GetNode<Camera3D>("Camera3D"); // This is the third-person camera
		firstPersonCamera = GetNode<Camera3D>("FirstPersonCamera3D"); // This should be the new first-person camera

		// Set initial active camera (disable first-person at start)
		thirdPersonCamera.Current = true;
		firstPersonCamera.Current = false;

		// Grab label
		_infoLabel = GetNode<Label>("CanvasLayer/infoLabel");
		GD.Print("Label found: " + (_infoLabel != null));
		InitializeLogging();
	}

	public override void _PhysicsProcess(double delta)
	{
		// Toggle camera on key press
		if (Input.IsActionJustPressed("toggle_camera"))
		{
			ToggleCamera();
		}

		// Check if the tank is tipped over
		//if (!IsUpright())
		//{
			//return;
		//}

		// Movement logic as before
		Vector3 forwardDir = -GlobalTransform.Basis.Z.Normalized();
		Vector3 rightDir = GlobalTransform.Basis.X.Normalized();
		Vector3 force = Vector3.Zero;

		if (Input.IsActionPressed("move_forward"))
		{
			force += forwardDir * movementSpeed;
		}
		if (Input.IsActionPressed("move_backward"))
		{
			force -= forwardDir * movementSpeed;
		}

		ApplyCentralForce(force);

		if (Input.IsActionPressed("move_left"))
		{
			ApplyCentralForce(-rightDir * rotationSpeed);
			ApplyCentralForce(forwardDir * rotationSpeed);
		}
		if (Input.IsActionPressed("move_right"))
		{
			ApplyCentralForce(rightDir * rotationSpeed);
			ApplyCentralForce(-forwardDir * rotationSpeed);
		}

		// Grab info label and update dynamically
		if (_infoLabel == null)
		{
			_infoLabel = GetNode<Label>("CanvasLayer/infoLabel");
			if (_infoLabel == null)
			{
				GD.PrintErr("Unable to find Label node!");
				return;
			}
		}
		UpdateInfoLabel();
		GD.Print("Label text: " + _infoLabel.Text);
		LogData();
	}

	private float IsUpright()
	{
		Vector3 objectUp = GlobalTransform.Basis.Y.Normalized();
		Vector3 worldUp = Vector3.Up;
		
		float angle = Mathf.Acos(objectUp.Dot(worldUp));
		return Mathf.RadToDeg(angle);
	}

	private void ToggleCamera()
	{
		isThirdPersonActive = !isThirdPersonActive;

		// Switch cameras
		thirdPersonCamera.Current = isThirdPersonActive;
		firstPersonCamera.Current = !isThirdPersonActive;
	}

	private void UpdateInfoLabel()
	{
		if (_infoLabel == null)
		{
			GD.PrintErr("_infoLabel is null in UpdateInfoLabel()");
			return;
		}
		float angleRelativeToGround = IsUpright();
		bool isFlipped = angleRelativeToGround > 45;
		Vector3 velocity = LinearVelocity;
		Vector3 position = GlobalTransform.Origin;
		string infoText = $"Position: ({position.X:F2}, {position.Y:F2}, {position.Z:F2})\n" +
					  $"Angle Relative to Ground: {angleRelativeToGround}\n" +
					  $"Flipped Over: {isFlipped}\n" + 
					  $"Velocity: ({velocity.X:F2}, {velocity.Y:F2}, {velocity.Z:F2})\n"; 
		
		_infoLabel.Text = infoText;
	}
	
	private void InitializeLogging()
	{
		try
		{
			logWriter = new StreamWriter(ProjectSettings.GlobalizePath(LOG_FILE_PATH), true);
			logWriter.WriteLine("Timestamp,Position_X,Position_Y,Position_Z,Angle,IsFlipped,Velocity_X,Velocity_Y,Velocity_Z");
		}
		catch (Exception e)
		{
			GD.PrintErr($"Failed to initialize logging: {e.Message}");
		}
	}
	
	private void LogData()
	{
		if (logWriter == null) return;

		float angleRelativeToGround = IsUpright();
		bool isFlipped = angleRelativeToGround > 45;
		Vector3 velocity = LinearVelocity;
		Vector3 position = GlobalTransform.Origin;

		string logEntry = $"{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}," +
						  $"{position.X:F2},{position.Y:F2},{position.Z:F2}," +
						  $"{angleRelativeToGround:F2},{isFlipped}," +
						  $"{velocity.X:F2},{velocity.Y:F2},{velocity.Z:F2}";

		// Log to stdout
		GD.Print(logEntry);

		// Log to CSV file
		try
		{
			logWriter.WriteLine(logEntry);
			logWriter.Flush(); // Ensure data is written immediately
		}
		catch (Exception e)
		{
			GD.PrintErr($"Failed to write to log file: {e.Message}");
		}
	}

	public override void _ExitTree()
	{
		// Close the log file when the node is removed from the scene
		if (logWriter != null)
		{
			logWriter.Close();
			logWriter = null;
		}
	}
}
