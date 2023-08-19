extends Control

onready var option_menu = $OptionsMenu

func play_difficulty(difficulty):
	GS.reset_game_state()
	GS.difficulty_multiplier = difficulty
	SceneTransition.transition_to(GS.Game)

# For now: All difficulty configuration will simply occur in these
# method definitions.
#
# Note that when we restart the game through the quit menu, the
# GS.difficulty_multiplier variable is not changed.
func _on_PlayNormal_pressed():
	play_difficulty(1)

func _on_PlayHarder_pressed():
	play_difficulty(1.2)

func _on_Options_pressed():
	option_menu.open()



