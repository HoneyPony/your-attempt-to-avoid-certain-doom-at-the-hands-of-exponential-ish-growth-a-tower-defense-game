extends "res://towers/TowerBase.gd"

var fire_timer = 0
var fire_timer_max = 0.7

onready var bullet_spawn_point = $BulletSpawnPoint

func _ready():
	fire_timer = fire_timer_max

func fire(delta):
	var bullet = GS.BasicBullet.instance()
	bullet.position = position + bullet_spawn_point.position + velocity * delta
	bullet.hits_left = 1
	get_parent().add_child(bullet)

func ship_fx():
	ship_sprite.position.y = 8 * sin(Time.get_ticks_msec() / 1000.0)
	
	var rot_target = (velocity.x / movement_speed) * (TAU / 16.0)
	ship_sprite.rotation += (rot_target - ship_sprite.rotation) * 0.09

func _physics_process(delta):
	fire_timer -= delta
	if fire_timer <= 0:
		fire_timer = fire_timer_max
		fire(delta)
		
	ship_fx()
