extends "res://towers/TowerBase.gd"

const SIDE_LASER_POSITION = 654

func _physics_process(delta):
	# The side laser never moves from.. well.. the side.
	position.x = SIDE_LASER_POSITION
