extends CanvasLayer

func win():
	if GS.game_state == GS.GameState.PLAYING:
		$WinScreen/AnimationPlayer.play("Open")
		GS.game_state = GS.GameState.WON
		
		Sounds.win()
	
func lose():
	var fs = $LoseScreen/FinalScore
	fs.text = str("Your final score:\n", GS.total_money)
	
	# Basically any state can transition into LOST.
	if GS.game_state != GS.GameState.LOST:
		$LoseScreen/AnimationPlayer.play("Open")
		GS.game_state = GS.GameState.LOST
		
		Sounds.lose()


func _on_StartOver_pressed():
	get_tree().paused = false
	# We MUST reset game state.
	GS.reset_game_state()
	SceneTransition.transition_to(GS.Game)
	
	Sounds.click1()


func _on_QuitToMenu_pressed():
	get_tree().paused = false
	SceneTransition.transition_to(GS.MainMenu)

	Sounds.click1()

func _on_FreePlay_pressed():
	get_tree().paused = false
	GS.game_state = GS.GameState.FREEPLAY
	$WinScreen/AnimationPlayer.play("Close")
	
	Sounds.click1()
	
func pause():
	# Make sure nothing funny happens while the menu is open.
	get_tree().paused = true
