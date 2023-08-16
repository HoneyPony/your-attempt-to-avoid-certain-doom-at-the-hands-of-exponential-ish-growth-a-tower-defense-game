extends Node

var Virus = preload("res://virus/Virus.tscn")
var VirusDebris = preload("res://virus/VirusDebris.tscn")

var BasicBullet = preload("res://towers/BasicBullet.tscn")
var SideLaserBullet = preload("res://towers/SideLaserBullet.tscn")

var game_camera: Camera2D = null

# Game stats
var money: int = 0
var lives: int = 0

# Resets all the values in GS that are relevant to starting a game.
# It's sort of like rebooting the game.
#
# In fact, most values should only be written here, so that they can't get out
# of sync. E.g. lives is set to 0 above, but 200 in here, as it should be.
func reset_game_state():
	game_camera = null
	
	money = 0
	lives = 200
	
func _ready():
	reset_game_state()

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
