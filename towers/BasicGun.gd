extends Area2D

var fire_timer = 0
var fire_timer_max = 0.8

func _ready():
	fire_timer = fire_timer_max

func fire():
	var bullet = GS.BasicBullet.instance()
	bullet.position = position
	get_parent().add_child(bullet)

func _physics_process(delta):
	fire_timer -= delta
	if fire_timer <= 0:
		fire_timer = fire_timer_max
		fire()
