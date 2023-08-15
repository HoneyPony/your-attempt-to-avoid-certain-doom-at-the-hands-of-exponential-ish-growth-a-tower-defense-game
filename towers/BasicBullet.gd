extends KinematicBody2D

var hits_left = 1

var velocity = 450
var lifetime = 4

func _ready():
	# Make bullets spawn in small then grow
	scale.x = 0.05
	scale.y = 0.05

func _physics_process(delta):
	position.y -= delta * velocity
	# Bullets get faster over time
	velocity += 180 * delta
	
	var target_scale_x = 0.5
	var target_scale_y = (0.5 + ((velocity - 240) / 400))
	var target_scale = Vector2(target_scale_x, target_scale_y)
	
	scale += (target_scale - scale) * 0.09
	
	lifetime -= delta
	if lifetime < 0:
		queue_free()
	
	
# Shoudl be called when the bullet hits an enemy (or other obstacles).
func hit_something():
	hits_left -= 1
	if hits_left <= 0:
		# TODO: animation / particles
		queue_free()
