extends Node2D
class_name VirusCollection

var used_coordinates = { Vector2(0, 0): true }

var spawn_timer = 1.0
# Default value of 0.5? This will be a huge factor on the game.
var spawn_timer_max = 2.0

func _process(delta):
	# Each frame, we try to spawn, depending on the spawn speed
	spawn_timer -= delta
	if spawn_timer < 0:
		# Reset timer
		spawn_timer = spawn_timer_max	
		try_spawns()
		
	
func spawn(virus, coord):
	used_coordinates[coord] = true
	
	var v = GS.Virus.instance()
	v.coord = coord
	v.rotation = rand_range(-PI, PI)
	v.scale.x = rand_range(0, 0.1)
	v.scale.y = v.scale.x
	
	# The virus spawns from it's "parent"'s position
	v.position = virus.position
	add_child(v)
	
func try_spawn(virus, coord):
	if coord in used_coordinates:
		return false
		
	spawn(virus, coord)
	return true
	
	
func try_spawns():
	var coord_deltas = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	
	# For spawning:
	# We simply iterate over all children and try spawning in a
	# random direction. If the spawn succeeds, great; that uses
	# up one of our max. Otherwise, try again...
	#
	# One thought: we could move this logic to the children, just
	# so that they could each have an individual timer, which would
	# be much more chaotic.
	var max_spawns = get_child_count()
	var spawn_attempts = max_spawns * 3

	var total_spawns = 0
	for i in range(0, spawn_attempts):
		if total_spawns >= max_spawns:
			return
			
		var virus = get_child(randi() % get_child_count())
		var coord = virus.coord
		if try_spawn(virus, coord + coord_deltas[randi() % 4]):
			total_spawns += 1

func free_coord(coord):
	used_coordinates.erase(coord)
