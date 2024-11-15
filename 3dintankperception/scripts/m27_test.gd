extends VehicleBody3D


var power = 500
var left
var right
var center_of_mass_marker: MeshInstance3D
var current_camera = 0
var cameras

# UI elements
var info_label: Label

# Logging
const LOG_FILE_PATH = "user://tank_log_curr1.csv" # note this will be in the user dir (search up where that is for ur machine)
var log_file: FileAccess

func _ready():
	
	# Create a small sphere mesh for the center of mass marker
	center_of_mass_marker = MeshInstance3D.new()
	center_of_mass_marker.mesh = SphereMesh.new()
	center_of_mass_marker.mesh.radius = 0.1  # Adjust for visibility
	center_of_mass_marker.material_override = StandardMaterial3D.new()
	center_of_mass_marker.material_override.albedo_color = Color(1, 0, 0)  # Set color to red

	# Add marker as a child of the VehicleBody3D
	add_child(center_of_mass_marker)

	# Get the existing info_label
	info_label = $CanvasLayer_UI/infoLabel
	print_scene_tree()
	# Initialize logging
	initialize_logging()

func _process(delta):
	# Get the current center of mass position
	var com_position = get_center_of_mass()
	
	# Update the position of the center of mass marker in local space
	center_of_mass_marker.transform.origin = com_position
	
	#if Input.is_action_just_pressed("toggle_view"):
		#toggle_camera_view()
	
	update_info_label()
	log_data()

func _physics_process(delta: float) -> void:
	# get keyboard
	left = int((Input.get_action_raw_strength("left_tread_forward")
		- Input.get_action_raw_strength("left_tread_backward")) * 10)
	right = int((Input.get_action_raw_strength("right_tread_forward")
		- Input.get_action_raw_strength("right_tread_backward")) * 10)
	
	# handle only one input
	if not left and right:
		$left_middle.engine_force = right * power
	elif left and not right:
		$right_middle.engine_force = left * power
	else:
		$left_middle.engine_force = left * power
		$right_middle.engine_force = right * power
		
		#$LeftWheelForward.engine_force = left * speed
		#$RightWheelForward.engine_force = right * speed
		#
		#$LeftWheelBack.engine_force = left * speed
		#$RightWheelBack.engine_force = right * speed
	
	print($left_middle.engine_force, $right_middle.engine_force)

func print_scene_tree():
	print_node(self, 0)

func print_node(node: Node, indent: int):
	var indent_string = "  ".repeat(indent)
	print(indent_string + node.name + " (" + node.get_class() + ")")
	for child in node.get_children():
		print_node(child, indent + 1)

func initialize_logging():
	log_file = FileAccess.open(LOG_FILE_PATH, FileAccess.WRITE)
	if log_file:
		log_file.store_line("Timestamp,Position_X,Position_Y,Position_Z,Angle,IsFlipped,Velocity_X,Velocity_Y,Velocity_Z")
	else:
		print("Failed to open log file")

func is_upright() -> float:
	var object_up = global_transform.basis.y.normalized()
	var world_up = Vector3.UP
	var angle = acos(object_up.dot(world_up))
	return rad_to_deg(angle)

func update_info_label():
	if info_label:
		var angle_relative_to_ground = is_upright()
		var is_flipped = angle_relative_to_ground > 45
		var velocity = linear_velocity
		var position = global_transform.origin
		
		var info_text = "Position: (%.2f, %.2f, %.2f)\n" % [position.x, position.y, position.z]
		info_text += "Angle Relative to Ground: %.2f\n" % angle_relative_to_ground
		info_text += "Flipped Over: %s\n" % str(is_flipped)
		info_text += "Velocity: (%.2f, %.2f, %.2f)" % [velocity.x, velocity.y, velocity.z]
		
		info_label.text = info_text
	else:
		print("Info label not found")

func log_data():
	var log_file = FileAccess.open(LOG_FILE_PATH, FileAccess.READ_WRITE)
	if log_file:
		var angle_relative_to_ground = is_upright()
		var is_flipped = angle_relative_to_ground > 45
		var velocity = linear_velocity
		var position = global_transform.origin
		
	
		var current_time_us = Time.get_ticks_usec()
		
	
		var datetime = Time.get_datetime_dict_from_system()
		var microseconds = current_time_us % 1000000
		var datetime_string = "%04d-%02d-%02d %02d:%02d:%02d.%06d" % [
			datetime.year, datetime.month, datetime.day,
			datetime.hour, datetime.minute, datetime.second,
			microseconds
		]
		
		var log_entry = "%s,%.2f,%.2f,%.2f,%.2f,%s,%.2f,%.2f,%.2f" % [
			datetime_string,
			position.x, position.y, position.z,
			angle_relative_to_ground, str(is_flipped),
			velocity.x, velocity.y, velocity.z
		]
		
		# Janky way of saving data every iteration because if the game prematurely end the files doesn't close
		log_file.seek_end()  
		log_file.store_line(log_entry)
		log_file.flush() 
		log_file.close()  
		print(log_entry)  
	else:
		print("Failed to open log file")


func _exit_tree():
	if log_file:
		log_file.close()
