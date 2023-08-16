extends Node

var Virus = preload("res://virus/Virus.tscn")
var VirusDebris = preload("res://virus/VirusDebris.tscn")

var BasicBullet = preload("res://towers/BasicBullet.tscn")
var SideLaserBullet = preload("res://towers/SideLaserBullet.tscn")

var game_camera: Camera2D = null

# These variables are used so that ships can coordinate who should be selected,
# when a tap overlaps multiple ships.
var selected_ship_map: Dictionary
var selected_ship_distance: Dictionary

func get_selected_ship(touch_index: int) -> Node2D:
	return selected_ship_map.get(touch_index, null)
	
func try_grab_selection(trying_ship: Node2D, touch_index: int, distance: float) -> bool:
	var ship = get_selected_ship(touch_index)
	if ship == null:
		selected_ship_distance[touch_index] = distance
		selected_ship_map[touch_index] = trying_ship
		return true
		
	# The map should always have a value...
	var cur_dist = selected_ship_distance.get(touch_index, 11111111)
	if cur_dist == 11111111:
		print("warning! selected_ship_distance did not have an entry")
		
	if distance < cur_dist:
		selected_ship_map[touch_index].deselect()
		
		selected_ship_distance[touch_index] = distance
		selected_ship_map[touch_index] = trying_ship
		return true
	
	return false

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
