extends Control

var option_button
var selected_map = "res://original.tscn"

func _ready():
	option_button = OptionButton.new()
	$VBoxContainer.add_child(option_button)
	
	option_button.position = Vector2(100, 100)
	option_button.custom_minimum_size = Vector2(200, 50)

	option_button.add_item("Map Original")
	option_button.add_item("Map Squares")
	option_button.add_item("Map Lumpy")
	option_button.add_item("Map Crater")
	option_button.add_item("Map Ramps")

	option_button.connect("item_selected", Callable(self, "_on_OptionButton_item_selected"))

	if not $VBoxContainer/StartButton.pressed.is_connected(Callable(self, "_on_StartButton_pressed")):
		$VBoxContainer/StartButton.pressed.connect(_on_StartButton_pressed)
	
	# Connect Help and Quit buttons
	if not $VBoxContainer/HelpButton.pressed.is_connected(Callable(self, "_on_HelpButton_pressed")):
		$VBoxContainer/HelpButton.pressed.connect(_on_HelpButton_pressed)
	
	if not $VBoxContainer/QuitButton.pressed.is_connected(Callable(self, "_on_QuitButton_pressed")):
		$VBoxContainer/QuitButton.pressed.connect(_on_QuitButton_pressed)
		
	if not $VBoxContainer/ConfigButton.pressed.is_connected(Callable(self, "_on_ConfigButton_pressed")):
		$VBoxContainer/ConfigButton.pressed.connect(_on_ConfigButton_pressed)

func _on_OptionButton_item_selected(index):
	var selected_text = option_button.get_item_text(index)
	print("Selected: " + selected_text)
	match selected_text:
		"Map Original":
			selected_map = "res://original.tscn"
		"Map Squares":
			selected_map = "res://squares.tscn"
		"Map Lumpy":
			selected_map = "res://lumpy.tscn"
		"Map Crater":
			selected_map = "res://crater.tscn"
		"Map Ramps":
			selected_map = "res://ramps.tscn"
		_:
			selected_map = "res://original.tscn"  

func _on_StartButton_pressed():
	print("Loading map: " + selected_map)
	var result = get_tree().change_scene_to_file(selected_map)
	if result != OK:
		print("Failed to change scene. Error code: ", result)
	else:
		print("Scene change initiated successfully")

func _on_HelpButton_pressed():
	# Change to the Help menu scene
	var result = get_tree().change_scene_to_file("res://help_menu.tscn")
	if result != OK:
		print("Failed to open Help menu. Error code: ", result)
	else:
		print("Help menu opened successfully")

func _on_ConfigButton_pressed():
	var config_menu = preload("res://config_menu.tscn").instantiate()
	config_menu.config_saved.connect(_on_config_saved)
	config_menu.config_closed.connect(_on_config_closed)
	get_tree().root.add_child(config_menu)
	self.hide()  # Hide the main menu

func _on_config_saved(wheel_mass, body_mass, arm_body_mass):
	print("Configuration saved. Wheel mass: ", wheel_mass, " Body mass: ", body_mass, " Arm body mass: ", arm_body_mass)
	# Apply these values to your game objects here
	self.show()  # Show the main menu again

func _on_config_closed():
	print("Config menu closed without saving")
	self.show()  # Show the main menu again


func _on_QuitButton_pressed():
	# Quit the game
	get_tree().quit()
