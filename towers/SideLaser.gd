extends "res://towers/TowerBase.gd"

const SIDE_LASER_POSITION = 656

onready var bullet_spawn_point = $BulletSpawnPoint

var current_bullet = null
	
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

func _physics_process(delta):
	# The side laser never moves from.. well.. the side.
	position.x = SIDE_LASER_POSITION
	
	if GS.timer_fires[GS.TIMER_SIDE_LASER]:
		fire()
		
	if is_instance_valid(current_bullet):
		if current_bullet.position.x >= (position.x - 4 * (28 + 16)):
			current_bullet.position.y = bullet_spawn_point.global_position.y
		
