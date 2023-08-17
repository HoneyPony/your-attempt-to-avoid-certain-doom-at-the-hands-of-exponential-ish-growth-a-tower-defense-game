extends ColorRect

func _process(delta):
	visible = get_tree().paused

func _on_ResumeButton_pressed():
	get_tree().paused = false
