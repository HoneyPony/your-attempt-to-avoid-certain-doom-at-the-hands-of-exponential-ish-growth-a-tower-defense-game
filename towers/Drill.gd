extends "res://towers/TowerBase.gd"

var hit_timer = 0.5
var hit_timer_max = 0.5

onready var damager_col = $Damager/CollisionShape2D

func _ready():
	damager_col.disabled = true

func _physics_process(delta):
	hit_timer -= delta
	if hit_timer < 0:
		hit_timer = hit_timer_max
		damager_col.disabled = false
	else:
		damager_col.disabled = true
		
