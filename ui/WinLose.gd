extends CanvasLayer

func win():
	if GS.game_state == GS.GameState.PLAYING:
		$WinScreen/AnimationPlayer.play("Open")
		GS.game_state = GS.GameState.WON
	
func lose():
	# Basically any state can transition into LOST.
	if GS.game_state != GS.GameState.LOST:
		$LoseScreen/AnimationPlayer.play("Open")
		GS.game_state = GS.GameState.LOST


func _on_StartOver_pressed():
	SceneTransition.transition_to(GS.Game)


func _on_QuitToMenu_pressed():
	SceneTransition.transition_to(GS.MainMenu)


func _on_FreePlay_pressed():
	GS.game_state = GS.GameState.FREEPLAY
	$WinScreen/AnimationPlayer.play("Close")
