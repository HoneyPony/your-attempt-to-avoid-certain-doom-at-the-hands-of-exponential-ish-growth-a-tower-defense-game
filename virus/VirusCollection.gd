extends Node2D
class_name VirusCollection

var used_coordinates = { Vector2(0, 0): true }

# coordinates to be avoided - so that the shapes might be more interesting..?
var avoid_coordinates = {}

# Keeps track of generations that a given cell has taken on. That way, cells
# that replace killed cells will age... this makes the game more winnable.
var previous_generations = {}

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
		
	# At most a 64th circle per second
	angular_drift = rand_range(-TAU, TAU) / 64

# Controls the spawn timer of all child viruses.
export var spawn_timer_max = 2.0

func free_coord(coord):
	used_coordinates.erase(coord)
	
	
# Random amount of rotation
var angular_drift = 0

func _physics_process(delta):
	var velocity = (260) / (4 + sqrt(get_child_count()))
	#print(velocity)
	
	# The collection slowly moves down towards the bottom of the screen.
	position.y += velocity * delta
	
	rotation += angular_drift * delta
	
func get_generation(cell, from_parent_value):
	var g = from_parent_value
	
	if previous_generations.has(cell):
		g = max(g, previous_generations[cell] + 1)
	
	previous_generations[cell] = g
	return g
