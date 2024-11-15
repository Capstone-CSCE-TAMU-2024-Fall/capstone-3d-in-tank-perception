extends VehicleBody3D

var speed = 5
var left
var right

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	
	# get keyboard
	left = int((Input.get_action_raw_strength("left_tread_forward")
		- Input.get_action_raw_strength("left_tread_backward")) * 10)
	right = int((Input.get_action_raw_strength("right_tread_forward")
		- Input.get_action_raw_strength("right_tread_backward")) * 10)
	
	# Debug output
	#print(left)
	#print(right)
	#print("--------")
	
	$LeftWheel.engine_force = left * speed
	$RightWheel.engine_force = right * speed
