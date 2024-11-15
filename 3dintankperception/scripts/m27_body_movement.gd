extends MeshInstance3D

var arm_speed = 0.005

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#print(position.y)
	
	var elevation = 0
	if Input.is_action_pressed("body_down"):
		if position.y >= 0.03635939955711:
			elevation -= 1
	if Input.is_action_pressed("body_up"):
		if position.y < 0.3:
			elevation += 1
	
	position.y += elevation * arm_speed
