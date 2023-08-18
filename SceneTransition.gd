extends CanvasLayer

var next_scene = null

func transition_to(scene: PackedScene):
	# Prevent any double-calls
	if next_scene == null:
		next_scene = scene
		$AnimationPlayer.play("Transition")
		
func transition_now():
	get_tree().change_scene_to(next_scene)
	
	# Always unpause we we enter a new scene
	get_tree().paused = false
	next_scene = null
