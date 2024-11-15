extends Path3D


var time = 0
var speed_div = 10
var speed
var offset = 0.72

@onready var links = $".".get_children()
@onready var tank = get_parent()

func _process(delta):
	
	speed = -tank.right / speed_div
	
	time += delta
	var count = 0
	for index in links:
		index.progress = speed * time + (offset * count)
		count += 1
