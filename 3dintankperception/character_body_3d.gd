extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 5
# Rotation speed of the tank
@export var rotation_speed = 2.0
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	var forward_input = Input.get_axis("ui_down", "ui_up")
	var rotation_input = Input.get_axis("ui_left", "ui_right")
	# Apply rotation
	rotate_y(-rotation_input * rotation_speed * delta)
	# calculate forward input
	var forward_velocity = -global_transform.basis.z * forward_input * speed

	# Ground Velocity
	target_velocity.x = forward_velocity.x
	target_velocity.z = forward_velocity.z
	
	# Rotation
	rotate_y(-rotation_input * rotation_speed * delta)
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
