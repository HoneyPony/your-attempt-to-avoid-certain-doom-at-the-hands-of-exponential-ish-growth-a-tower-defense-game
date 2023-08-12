extends Node2D

var parent_vc: VirusCollection = null
var coord: Vector2 = Vector2.ZERO

func _ready():
	parent_vc = get_parent()
	$Energy.material.set_shader_param("rng_source", Vector2(rand_range(0, 16), rand_range(0, 16)))

	var overlay_rot_options = [0, TAU/4, TAU/2, 0.75 * TAU]
	$Overlay.rotation = overlay_rot_options[randi() % 4]

func destroy():
	parent_vc.free_coord(coord)

func _physics_process(delta):
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
	pass
