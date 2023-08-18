extends "res://towers/BulletBase.gd"

var velocity = 800

func _physics_process(delta):
	move_and_slide(Vector2(0, -velocity))
