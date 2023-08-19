extends Node2D

# Used to determine how many things this bullet can go through. I.e. "piercing"
export var hits_left = 1
export var lifetime = 4

export var point0: Vector2
export var point1: Vector2

var index1 = -1
var index2 = -1

var must_add_collide = false

func _ready():
	add_to_group("ResettableColliders")
	
func reset_collision(hit_indices):
	var hit = (index1 in hit_indices) or (index2 in hit_indices)
	if hit:
		hit_something()
		
	must_add_collide = true

# Should be called when the bullet hits an enemy (or other obstacles).
func hit_something():
	hits_left -= 1
	if hits_left <= 0:
		# TODO: animation / particles
		queue_free()
		must_add_collide = false

func _physics_process(delta):
	if must_add_collide:
		# Assumption: our position is equal to global_position
		index1 = GS.push_collision_point(position + point0)
		index2 = GS.push_collision_point(position + point1)
		must_add_collide = false
	
	# All bullets SHOULD despawn at some point.
	lifetime -= delta
	if lifetime < 0:
		queue_free()
