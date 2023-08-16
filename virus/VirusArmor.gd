extends Sprite

var drift = Vector2.ZERO
var rot_drift = 0

var life_timer = -1

func _ready():
	hide()
	set_physics_process(false)
	
func activate():
	scale = Vector2(0, 0)
	show()
	set_physics_process(true)
	
func destroy():
	drift = polar2cartesian(rand_range(20, 70), rand_range(0, TAU))
	rot_drift = rand_range(-TAU, TAU) / 64.0
	
	life_timer = 0.8
	
func _physics_process(delta):
	var t_scale = 4 * Vector2.ONE
	if life_timer > 0:
		t_scale = Vector2.ZERO
	scale += (t_scale - scale) * 0.02
	
	position += drift * delta
	rotation += rot_drift * delta
	
	if life_timer > 0:
		life_timer -= delta
		if life_timer < 0:
			queue_free()
