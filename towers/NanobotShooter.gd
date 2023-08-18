extends "res://towers/TowerBase.gd"

onready var bullet_spawn_point = $BulletSpawnPoint

var fire_timer = 0

func reset_fire_timer():
	# The nano bot shooter is sporadic.
	if left_level == 0:
		fire_timer = rand_range(0.3, 1.2)
	elif left_level == 1:
		fire_timer = rand_range(0.35, 0.9)
	elif left_level == 2:
		fire_timer = rand_range(0.4, 0.7)
	
func _ready():
	reset_fire_timer()

func fire(delta):
	var bullet = GS.Nanobot.instance()
	bullet.position = position + bullet_spawn_point.position + velocity * delta
	if right_level == 1:
		bullet.aging = 2
	if right_level == 2:
		bullet.aging = 5
	get_parent().add_child(bullet)

func ship_fx():
	ship_sprite.position.y = 8 * sin(Time.get_ticks_msec() / 1000.0)
	
	var rot_target = (velocity.x / movement_speed) * (TAU / 16.0)
	ship_sprite.rotation += (rot_target - ship_sprite.rotation) * 0.09

func _physics_process(delta):
	fire_timer -= delta
	if fire_timer < 0:
		reset_fire_timer()
		fire(delta)
	ship_fx()
