extends "res://towers/TowerBase.gd"

onready var damager_col = $Damager/CollisionShape2D

# Same deal as SideLaser
var base_speed

func _ready():
	base_speed = movement_speed
	damager_col.disabled = true
	
func compute_movement_speed():
	movement_speed = base_speed
	if right_level > 0:
		movement_speed *= 1.2
	if right_level > 1:
		movement_speed *= 1.2

func _physics_process(delta):
	compute_movement_speed()
	
	if GS.timer_fires[GS.TIMER_DRILL_LEVEL_0 + left_level]:
		damager_col.disabled = false
	else:
		damager_col.disabled = true
		
