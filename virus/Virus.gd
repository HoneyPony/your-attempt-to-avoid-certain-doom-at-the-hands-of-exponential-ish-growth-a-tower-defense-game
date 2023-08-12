extends Node2D

var parent_vc: VirusCollection = null
var coord: Vector2 = Vector2.ZERO

var spawn_timer = 1.0
var direction_preference = null

func _ready():
	parent_vc = get_parent()
	$Energy.material.set_shader_param("rng_source", Vector2(rand_range(0, 16), rand_range(0, 16)))

	var overlay_rot_options = [0, TAU/4, TAU/2, 0.75 * TAU]
	$Overlay.rotation = overlay_rot_options[randi() % 4]

func destroy():
	parent_vc.free_coord(coord)

func _physics_process(delta):
	# Each frame, we try to spawn, depending on the spawn speed
	spawn_timer -= delta
	if spawn_timer < 0:
		try_spawns()
		# Reset timer
		spawn_timer = parent_vc.spawn_timer_max * rand_range(0.95, 1.05)
	
	# Animate the spawn/jitter effects
	animate()
	
func animate():
	# Basic lerp-animation for spawning
	var target_scale = Vector2(1, 1)
	var target_rot = 0
	var target_pos = coord * 32 # 4x pixels, plus 8 pixels wide
	
	# Jitter animation:
	target_scale *= rand_range(0.9, 1.1)
	target_rot += rand_range(-0.1 * TAU, 0.1 * TAU)
	target_pos += polar2cartesian(rand_range(0, 4), rand_range(0, TAU))
	
	scale += (target_scale - scale) * 0.09
	
	rotation = lerp_angle(rotation, target_rot, 0.09)
	position += (target_pos - position) * 0.09

func spawn(coord, dir):
	parent_vc.used_coordinates[coord] = true
	
	var v = GS.Virus.instance()
	v.coord = coord
	v.rotation = rand_range(-PI, PI)
	v.scale.x = rand_range(0, 0.1)
	v.scale.y = v.scale.x
	
	# The virus spawns from it's "parent"'s position
	v.position = position
	
	# Grow in the same direction
	v.direction_preference = dir
	
	parent_vc.add_child(v)
	
func try_spawn(direction):
	var new_coord = coord + direction
	if new_coord in parent_vc.used_coordinates:
		return false
		
	spawn(new_coord, direction)
	return true
	
func try_spawns():
	var coord_deltas = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	
	if direction_preference != null:
		# Some percent of the time, try to grow in the same direction.
		if randf() < 0.8:
			# Temporary variable to save value
			var dir = direction_preference
			
			# Get rid of the direction prefernece afterwards, whether we spawn or not.
			direction_preference = null
			if try_spawn(dir):
				return
	
	# Try a couple times before giving up.
	for i in range(0, 3):
		var dir = coord_deltas[randi() % 4]
		if try_spawn(dir):
			return
