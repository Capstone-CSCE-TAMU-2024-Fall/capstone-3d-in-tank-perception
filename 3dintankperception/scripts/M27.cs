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

	private Vector3 _targetVelocity = Vector3.Zero;

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
}
