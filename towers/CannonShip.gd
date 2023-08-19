extends "res://towers/TowerBase.gd"

onready var bullet_spawn_point = $BulletSpawnPoint

func fire(delta):
	if state != State.NORMAL:
		return
	
	var bullet = GS.Missile.instance()
	bullet.position = position + bullet_spawn_point.position + velocity * delta
	bullet.explode = right_level
	get_parent().add_child(bullet)
	
	Sounds.cannon_shoot(left_level)

func ship_fx():
	ship_sprite.position.y = 8 * sin(Time.get_ticks_msec() / 1000.0)
	
	var rot_target = (velocity.x / movement_speed) * (TAU / 16.0)
	ship_sprite.rotation += (rot_target - ship_sprite.rotation) * 0.09

func _physics_process(delta):
	# These timers are SUPPOSED to be ordered in the array by left_level
	# if not, that should be fixed or it will be a bug!
	if GS.timer_fires[GS.TIMER_CANNON_LEVEL_0 + left_level]:
		fire(delta)
		
	ship_fx()
