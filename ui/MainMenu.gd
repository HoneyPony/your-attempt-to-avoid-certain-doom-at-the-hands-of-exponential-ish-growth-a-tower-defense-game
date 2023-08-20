extends Control

onready var option_menu = $OptionsMenu

func _ready():
	var options = $Options
	var wqb = $WithQuitButton
	
	var show_quit = true
	if OS.get_name() == "Web":
		show_quit = false
	if OS.get_name() == "Android":
		show_quit = false
	if OS.get_name() == "iOS":
		show_quit = false
		
	options.visible = not show_quit
	wqb.visible = show_quit

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
	Sounds.click1()

func _on_PlayHarder_pressed():
	play_difficulty(1.4)
	Sounds.click1()

func _on_Options_pressed():
	option_menu.open()
	Sounds.click1()

func _on_Quit_pressed():
	get_tree().quit()
