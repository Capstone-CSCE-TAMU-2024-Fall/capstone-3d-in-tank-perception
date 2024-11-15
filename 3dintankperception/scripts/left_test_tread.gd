extends Path3D


var time = 0
var speed_div = 10
var speed = 2
var offset = 0.4

@onready var links = $".".get_children()
@onready var tank = get_parent()

func _process(delta):
	
	time += delta
	var count = 0
	for index in links:
		index.progress = -(speed * time + (offset * count))
		count += 1
