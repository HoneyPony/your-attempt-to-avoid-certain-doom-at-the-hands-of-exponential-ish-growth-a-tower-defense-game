extends "res://towers/TowerBase.gd"

const SIDE_LASER_POSITION = 656

onready var bullet_spawn_point = $BulletSpawnPoint

var current_bullet = null

# Because the speed is being set in the inspector, we just grab this
# in _ready(). (maybe onready would work for this? that's something to check
# at some point maybe)
var base_speed = 0

func _ready():
	base_speed = movement_speed
	
func fire():
	var bullet = GS.SideLaserBullet.instance()
	bullet.position = bullet_spawn_point.global_position
	# May change when we add upgrades, etc
	# 360 is just enough to get to the edge of the screen with the default lifetime
	# of 4. We can change the lifetime of course, but this seems reasonable
	# for now.
	bullet.velocity = Vector2(-360, 0)
	
	# Piercing upgrade
	bullet.hits_left = 1 + right_level
	get_parent().add_child(bullet)
	
	current_bullet = bullet

func compute_movement_speed():
	# Compute our movement speed based on the literal description of the ugprade.
	movement_speed = base_speed
	if right_level > 0:
		movement_speed *= 1.2
	if right_level > 1:
		movement_speed *= 1.2

func _physics_process(delta):
	# One of our upgrades is movement speed
	compute_movement_speed()
	
	# The side laser never moves from.. well.. the side.
	position.x = SIDE_LASER_POSITION
	
	if GS.timer_fires[GS.TIMER_SIDE_LASER]:
		fire()
		
	if is_instance_valid(current_bullet):
		if current_bullet.position.x >= (position.x - 4 * (28 + 16)):
			current_bullet.position.y = bullet_spawn_point.global_position.y
		
