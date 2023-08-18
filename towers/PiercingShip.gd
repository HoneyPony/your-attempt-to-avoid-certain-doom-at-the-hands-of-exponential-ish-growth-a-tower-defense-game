extends "res://towers/TowerBase.gd"

onready var bullet_spawn_point = $BulletSpawnPoint

func fire(delta):
	if state != State.NORMAL:
		return
	
	var missile = 1 if left_level >= 1 else 0
	
	var bullet = GS.KineticMissile[missile].instance()
	bullet.position = position + bullet_spawn_point.position + velocity * delta
	
	var piercing = [5, 8, 17]
	bullet.hits_left = piercing[right_level]
	
	get_parent().add_child(bullet)

func ship_fx():
	ship_sprite.position.y = 8 * sin(Time.get_ticks_msec() / 1000.0)
	
	var rot_target = (velocity.x / movement_speed) * (TAU / 16.0)
	ship_sprite.rotation += (rot_target - ship_sprite.rotation) * 0.09

func _physics_process(delta):
	var timer_index = 0
	if left_level >= 2:
		timer_index = 1
	if GS.timer_fires[GS.TIMER_PIERCING_LEVEL_0 + timer_index]:
		fire(delta)
		
	ship_fx()
