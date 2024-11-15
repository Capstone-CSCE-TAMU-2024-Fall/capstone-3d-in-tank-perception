extends CharacterBody3D

# Dozer Physical Constraints
const LENGTH = 2.865  # in meters (112 3/4 inches)
const WIDTH = 0.705  # in meters (27 3/4 inches)
const HEIGHT_LOWEST = 0.567  # in meters (22 5/16 inches)
const HEIGHT_HIGHEST = 0.745  # in meters (29 5/16 inches)
const BUCKET_MAX_HEIGHT = 1.588  # in meters (62 1/2 inches)
const BUCKET_CLEARANCE_MAX = 0.9525  # in meters (37 1/2 inches)
const TURNING_DIAMETER = 4.14  # in meters (163 inches)
const WEIGHT = 1088.62  # in kg (2400 lbs)

# Movement parameters
@export var max_speed = 5.0  # meters per second
@export var turn_speed = 1.0  # speed at which the dozer turns
@export var bucket_speed = 0.5  # speed of raising/lowering the bucket

var bucket_height = 0.0  # Current height of the bucket

# Movement logic
func move_dozer(direction: Vector3, delta: float):
	# Limit the movement speed based on max speed
	var target_velocity = direction * max_speed
	move_and_slide(target_velocity)

# Turning logic
func turn_dozer(direction: float, delta: float):
	# turning logic based on turning diameter (simulate tank-like movement)
	rotation.y += direction * turn_speed * delta
