extends Node2D
class_name VirusCollection

var used_coordinates = { Vector2(0, 0): true }

# coordinates to be avoided - so that the shapes might be more interesting..?
var avoid_coordinates = {}

func random_avoid_value():
	# Never generate 0
	var v = 1 + (randi() % 15)
	if randf() < 0.5:
		v = -v
	return v
	

func _ready():
	for i in range(0, 60):
		var a = Vector2(random_avoid_value(), random_avoid_value())
		avoid_coordinates[a] = true

# Controls the spawn timer of all child viruses.
var spawn_timer_max = 2.0

func free_coord(coord):
	used_coordinates.erase(coord)
