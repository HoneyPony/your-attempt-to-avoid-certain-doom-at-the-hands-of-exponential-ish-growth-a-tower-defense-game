extends Sprite

func _process(delta):
	visible = GS.show_upgrade_icon
	
	if is_instance_valid(GS.upgrade_target_ship):
		position = GS.upgrade_target_ship.position
	else:
		visible = false
