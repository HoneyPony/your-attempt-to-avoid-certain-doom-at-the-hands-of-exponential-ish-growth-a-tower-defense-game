extends "res://towers/BulletBase.gd"

var velocity = 450
var explode = 0

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
	var explosion = GS.Explosions[explode].instance()
	explosion.position = position
	get_parent().add_child(explosion)
	
	# We will be queu_freed due to super hit_something
	Sounds.missile_explode()
