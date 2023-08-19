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
	get_tree().paused = false
	# We MUST reset game state.
	GS.reset_game_state()
	SceneTransition.transition_to(GS.Game)


func _on_QuitToMenu_pressed():
	get_tree().paused = false
	SceneTransition.transition_to(GS.MainMenu)


func _on_FreePlay_pressed():
	get_tree().paused = false
	GS.game_state = GS.GameState.FREEPLAY
	$WinScreen/AnimationPlayer.play("Close")
	
func pause():
	# Make sure nothing funny happens while the menu is open.
	get_tree().paused = true
