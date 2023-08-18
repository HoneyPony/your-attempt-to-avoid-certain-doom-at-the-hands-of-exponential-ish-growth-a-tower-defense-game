extends Panel

onready var anim = $AnimationPlayer



func open():
	anim.play("Open")
	
func close():
	anim.play("Close")

func _on_ToggleFullscreenButton_pressed():
	OS.window_fullscreen = not OS.window_fullscreen


func _on_CloseOptions_pressed():
	close()
