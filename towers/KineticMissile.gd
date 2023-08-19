extends "res://towers/BulletBase.gd"

var velocity = 800

func _physics_process(delta):
	position += (Vector2(0, -velocity * delta))
