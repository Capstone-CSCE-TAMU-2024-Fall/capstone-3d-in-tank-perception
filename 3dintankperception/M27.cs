using Godot;
using System;

public partial class M27 : CharacterBody3D
{
	// How fast the player moves in meters per second.
	[Export]
	public int Speed { get; set; } = 14;
	// The downward acceleration when in the air, in meters per second squared.
	[Export]
	public int FallAcceleration { get; set; } = 75;

	// Rotation speed in radians per second
	[Export]
	public float RotationSpeed { get; set; } = 5.0f;

	// Timer for logging
	private Timer _loggingTimer;

	// Target velocity
	private Vector3 _targetVelocity = Vector3.Zero;

	public override void _Ready()
	{
		// Create a timer to log every 200ms
		_loggingTimer = new Timer();
		_loggingTimer.WaitTime = 0.2f; // 200ms
		_loggingTimer.OneShot = false; // Repeat timer
		_loggingTimer.Autostart = true;
		_loggingTimer.Connect("timeout", this, nameof(LogMovementData));
		AddChild(_loggingTimer);
	}

	public override void _PhysicsProcess(double delta)
	{
		var direction = Vector3.Zero;

		if (Input.IsActionPressed("move_right"))
		{
			RotateY(-RotationSpeed * (float)delta); // Rotate right
		}
		if (Input.IsActionPressed("move_left"))
		{
			RotateY(RotationSpeed * (float)delta); // Rotate left
		}

		// Get the forward direction based on the character's current rotation
		Vector3 forward = Transform.Basis.Z;
		Vector3 right = Transform.Basis.X;

		if (Input.IsActionPressed("move_back"))
		{
			direction += forward; // Move backward in the direction of facing
		}
		if (Input.IsActionPressed("move_forward"))
		{
			direction += -forward; // Move forward in the direction of facing
		}

		if (Input.IsActionPressed("move_right"))
		{
			direction += right; // Move right
		}
		if (Input.IsActionPressed("move_left"))
		{
			direction -= right; // Move left
		}

		// Normalize the direction vector
		if (direction.LengthSquared() > 0)
		{
			direction = direction.Normalized();
		}

		// Ground velocity
		_targetVelocity = direction * Speed;

		// Vertical velocity
		if (!IsOnFloor()) // If in the air, fall towards the floor. Literally gravity
		{
			_targetVelocity.Y -= FallAcceleration * (float)delta;
		}

		// Moving the character
		Velocity = _targetVelocity;
		MoveAndSlide();
	}


	// Method to log movement data
	private void LogMovementData()
	{
		Vector3 position = GlobalTransform.origin;
		Vector3 velocity = Velocity;
		float mass = Mass; 
		long timeInMillis = OS.GetTicksMsec(); // Get time in milliseconds

		// ASSUMED MASS DEFINED IN CharacterBody3D 
		//OR INHERITED FROM RigidBody 
		//OR HARD CODED FOR M27
		
		GD.Print($"Time: {timeInMillis} ms, Position: {position}, Velocity: {velocity}, Mass: {mass}");
	}
}
