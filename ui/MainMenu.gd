extends Control

func _on_PlayButton_pressed():
	GS.reset_game_state() # Reset the game state
	SceneTransition.transition_to(GS.Game)
