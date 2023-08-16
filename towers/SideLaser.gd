extends "res://towers/TowerBase.gd"

const SIDE_LASER_POSITION = 654

var fire_timer = 0
var fire_timer_max = 0.3

onready var bullet_spawn_point = $BulletSpawnPoint

func _ready():
	fire_timer = fire_timer_max
	
func fire():
	var bullet = GS.SideLaserBullet.instance()
	bullet.position = bullet_spawn_point.global_position
	# May change when we add upgrades, etc
	# 360 is just enough to get to the edge of the screen with the default lifetime
	# of 4. We can change the lifetime of course, but this seems reasonable
	# for now.
	bullet.velocity = Vector2(-360, 0)
	get_parent().add_child(bullet)

func _physics_process(delta):
	# The side laser never moves from.. well.. the side.
	position.x = SIDE_LASER_POSITION
	
	fire_timer -= delta
	if fire_timer <= 0:
		fire_timer = fire_timer_max
		fire()
		
