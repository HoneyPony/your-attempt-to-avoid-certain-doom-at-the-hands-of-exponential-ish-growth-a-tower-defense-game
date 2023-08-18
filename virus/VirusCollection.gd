extends Node2D
class_name VirusCollection

var used_coordinates = { Vector2(0, 0): true }

# coordinates to be avoided - so that the shapes might be more interesting..?
var avoid_coordinates = {}

# Keeps track of generations that a given cell has taken on. That way, cells
# that replace killed cells will age... this makes the game more winnable.
var previous_generations = {}

var priming_count = 0

var speed_mul = 1.0

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
	
# Literally runs viruses until the given count is satisfied.
func prime(prime_count):
	while true:
		var ccount = get_child_count()
		if ccount >= prime_count:
			return
			
		var cindex = randi() % ccount
		get_child(cindex).try_spawns()

# Controls the spawn timer of all child viruses.
export var spawn_timer_max = 2.0

func free_coord(coord, aging_amount):
	used_coordinates.erase(coord)
	previous_generations[coord] = previous_generations.get(coord, 0) + aging_amount
	
# Random amount of rotation
var angular_drift = 0

func _physics_process(delta):
	if priming_count > 0:
		prime(priming_count)
		priming_count = 0
	
	var velocity = (260) / (4 + sqrt(get_child_count()))
	#print(velocity)
	
	# The collection slowly moves down towards the bottom of the screen.
	position.y += velocity * delta * speed_mul
	
	rotation += angular_drift * delta
	
	# Virus collections go away when all their children are gone.
	if get_child_count() == 0:
		queue_free()
	
func get_generation(cell, from_parent_value):
	var g = from_parent_value
	
	if previous_generations.has(cell):
		g = max(g, previous_generations[cell] + 1)
	
	previous_generations[cell] = g
	return g
