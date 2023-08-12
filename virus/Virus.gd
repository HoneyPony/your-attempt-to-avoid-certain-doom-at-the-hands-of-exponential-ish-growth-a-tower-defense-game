extends Node2D

var parent_vc: VirusCollection = null
var coord: Vector2 = Vector2.ZERO

func _ready():
	parent_vc = get_parent()

func destroy():
	parent_vc.free_coord(coord)

func _physics_process(delta):
	# Basic lerp-animation for spawning
	var target_scale = Vector2(1, 1)
	var target_rot = 0
	var target_pos = coord * 32 # 4x pixels, plus 8 pixels wide
	
	scale += (target_scale - scale) * 0.09
	rotation += (target_rot - rotation) * 0.09
	position += (target_pos - position) * 0.09
	pass
