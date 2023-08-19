extends "res://towers/BulletBase.gd"

var velocity = 300
var aging = 1

func _physics_process(delta):
	position += (Vector2(0, -velocity * delta))
	$Sprite.rotation += TAU * delta * 0.25

func hit_something():
	# Call super method
	.hit_something()
	
	# Impact the age
