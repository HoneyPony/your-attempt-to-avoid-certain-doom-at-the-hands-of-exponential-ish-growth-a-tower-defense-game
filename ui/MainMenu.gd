extends Control

onready var option_menu = $OptionsMenu

func _on_PlayButton_pressed():
	GS.reset_game_state() # Reset the game state
	SceneTransition.transition_to(GS.Game)


func _on_Options_pressed():
	option_menu.open()
