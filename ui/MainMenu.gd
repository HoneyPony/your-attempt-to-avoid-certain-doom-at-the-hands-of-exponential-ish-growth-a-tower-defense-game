extends Control



func _on_PlayButton_pressed():
	#TODO: Add scene transition
	get_tree().change_scene_to(GS.Game)
