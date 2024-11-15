extends MeshInstance3D

var arm_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#print(position.y)
	
	var elevation = 0
	if Input.is_action_pressed("arm_down"):
		if rotation_degrees.x < 0:
			elevation += 1
	if Input.is_action_pressed("arm_up"):
		if rotation_degrees.x > -30:
			elevation -= 1
	
	rotation_degrees.x += elevation * arm_speed
