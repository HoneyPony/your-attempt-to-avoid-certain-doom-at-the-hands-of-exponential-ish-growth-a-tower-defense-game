extends "res://towers/BulletBase.gd"

var velocity = Vector2.ZERO

func _physics_process(delta):
	# Side laser bullets are very very very simple.
	# The only important thing is computing the correct velocity to match
	# the laser firing speed.
	move_and_slide(velocity)
