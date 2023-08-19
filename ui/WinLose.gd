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
