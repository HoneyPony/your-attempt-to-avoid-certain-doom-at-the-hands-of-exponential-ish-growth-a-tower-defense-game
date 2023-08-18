extends ColorRect

func _process(delta):
	visible = get_tree().paused
	if visible:
		# GS is paused, so we can do the fullscreen input for it
		GS.check_fullscreen_input()

func _on_ResumeButton_pressed():
	get_tree().paused = false
