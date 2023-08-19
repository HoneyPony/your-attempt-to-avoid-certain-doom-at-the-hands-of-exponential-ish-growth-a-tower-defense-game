extends "res://towers/BulletBase.gd"

var velocity = 450

func _ready():
	# Make bullets spawn in small then grow
	scale.x = 0.2
	scale.y = 0.2

func _physics_process(delta):
	position += Vector2(0, -velocity * delta)
	#move_and_slide(Vector2(0, -velocity))
	# Bullets get faster over time
	velocity += 180 * delta
	
	var target_scale_x = 0.5
	var target_scale_y = (0.5 + ((velocity - 240) / 400))
	var target_scale = Vector2(target_scale_x, target_scale_y)
	
	scale += (target_scale - scale) * 0.09
