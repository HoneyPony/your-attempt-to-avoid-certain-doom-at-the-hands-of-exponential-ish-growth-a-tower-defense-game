extends KinematicBody2D

# Used to determine how many things this bullet can go through. I.e. "piercing"
export var hits_left = 1
export var lifetime = 4

# Should be called when the bullet hits an enemy (or other obstacles).
func hit_something():
	hits_left -= 1
	if hits_left <= 0:
		# TODO: animation / particles
		queue_free()

func _process(delta):
	# All bullets SHOULD despawn at some point.
	lifetime -= delta
	if lifetime < 0:
		queue_free()
