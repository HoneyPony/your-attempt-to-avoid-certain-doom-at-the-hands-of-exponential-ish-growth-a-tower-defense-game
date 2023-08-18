extends ColorRect

onready var quit_menu = $QuitMenu
onready var quit_anim = $QuitMenu/AnimationPlayer

onready var options = $OptionsMenu

func _process(delta):
	var was_visible = visible
	visible = get_tree().paused
	if visible:
		# GS is paused, so we can do the fullscreen input for it
		GS.check_fullscreen_input()
		
		# If we just opened, hide all the sub menus
		if not was_visible:
			quit_anim.play("RESET")
			options.hide()

func _on_ResumeButton_pressed():
	get_tree().paused = false


func _on_ConfirmQuit_pressed():
	SceneTransition.transition_to(GS.MainMenu)

func hide_quit_menu():
	quit_anim.play("CloseQuitMenu")
	# Just in case: disable the actual quitting button
	# this is now accomplished by the CloseQuitMenu animation
	# quit_menu.get_node("ConfirmQuit").disabled = true

func _on_CancelQuit_pressed():
	hide_quit_menu()


func _on_QuitButton_pressed():
	# This will show the quit menu, and then disable the confirm button
	# temporarily (and then enable it), so as to prevent accidental quits.
	quit_anim.play("OpenQuitMenu")


func _on_OptionsButton_pressed():
	# We could just directly connect the button signal to this function...
	# but this works too.
	options.open()
