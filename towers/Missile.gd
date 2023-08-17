extends "res://towers/BulletBase.gd"

var velocity = 450

func _ready():
	# Make bullets spawn in small then grow
	#scale.x = 0.2
	#scale.y = 0.2
	pass

func _physics_process(delta):
	move_and_slide(Vector2(0, -velocity))
	# Bullets get faster over time
	velocity += 180 * delta

func hit_something():
	# Call super method
	.hit_something()
	
	# Explode (can't call this from signal)
	call_deferred("explode")

func explode():
	var explosion = GS.Explosions[0].instance()
	explosion.position = position
	get_parent().add_child(explosion)
