extends Control

@onready var wheelmass_input = $VBoxContainer/HBoxContainer/SpinBox
@onready var bodymass_input = $VBoxContainer2/HBoxContainer/SpinBox
@onready var armbodymass_input = $VBoxContainer3/HBoxContainer/SpinBox
@onready var save_button = $VBoxContainer/SaveButton
@onready var back_button = $VBoxContainer/BackButton

signal config_saved(wheel_mass, body_mass, arm_body_mass)
signal config_closed

func _ready():
	save_button.pressed.connect(_on_save_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

func _on_save_button_pressed():
	var config = ConfigFile.new()
	config.set_value("physics", "wheel_mass", wheelmass_input.value)
	config.set_value("physics", "body_mass", bodymass_input.value)
	config.set_value("physics", "arm_body_mass", armbodymass_input.value)
	config.save("user://config.cfg")
	emit_signal("config_saved", wheelmass_input.value, bodymass_input.value, armbodymass_input.value)
	print("Configuration saved")
	_return_to_main_menu()

func _on_back_button_pressed():
	emit_signal("config_closed")
	_return_to_main_menu()

func _return_to_main_menu():
	var main_menu = load("res://menu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	queue_free()  # Remove this config menu scene
