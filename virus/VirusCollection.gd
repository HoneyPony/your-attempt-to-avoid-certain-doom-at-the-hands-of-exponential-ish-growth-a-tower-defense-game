extends Node2D
class_name VirusCollection

var used_coordinates = { Vector2(0, 0): true }

# Controls the spawn timer of all child viruses.
var spawn_timer_max = 2.0

func free_coord(coord):
	used_coordinates.erase(coord)
