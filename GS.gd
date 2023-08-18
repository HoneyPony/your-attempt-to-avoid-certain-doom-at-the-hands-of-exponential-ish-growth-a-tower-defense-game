extends Node

# The GS is responsible for several gameplay timers, so that the time that
# the player buys a ship is not significant for synchronization.

var timer_basic_gun_level0 = 0
const timer_basic_gun_level0_MAX = 0.7
var timer_basic_gun_level1 = 0
const timer_basic_gun_level1_MAX = (0.7 / 1.2)
var timer_basic_gun_level2 = 0
const timer_basic_gun_level2_MAX = (0.7 / (1.2 * 1.2))

var timer_side_laser = 0
const timer_side_laser_MAX = (0.16)

var timer_drill_level0 = 0
const timer_drill_level0_MAX = 1.0
var timer_drill_level1 = 0
const timer_drill_level1_MAX = (1.0 / 1.5)
var timer_drill_level2 = 0
const timer_drill_level2_MAX = (1.0 / (1.5 * 2))

var timer_cannon_level0 = 0
const timer_cannon_level0_MAX = 1.4
var timer_cannon_level1 = 0
const timer_cannon_level1_MAX = (1.4 / 1.1)
var timer_cannon_level2 = 0
const timer_cannon_level2_MAX = (1.4 / (1.1 * 1.2))

const TIMER_BASIC_GUN_LEVEL_0 = 0
const TIMER_BASIC_GUN_LEVEL_1 = 1
const TIMER_BASIC_GUN_LEVEL_2 = 2 # These three should be in order
const TIMER_SIDE_LASER = 3
const TIMER_DRILL_LEVEL_0 = 4
const TIMER_DRILL_LEVEL_1 = 5
const TIMER_DRILL_LEVEL_2 = 6 # These three should be in order
const TIMER_CANNON_LEVEL_0 = 7 
const TIMER_CANNON_LEVEL_1 = 8
const TIMER_CANNON_LEVEL_2 = 9 # These three should be in order

var timer_fires = [
	false, # basic gun level 0
	false, # basic gun level 1
	false, # basic gun level 2
	false, # side laser
	false,
	false,
	false, # drill timers
	false,
	false,
	false, # cannon timers
]

func reset_timers():
	for i in range(0, timer_fires.size()):
		timer_fires[i] = false
	
	timer_basic_gun_level0 = timer_basic_gun_level0_MAX
	timer_basic_gun_level1 = timer_basic_gun_level1_MAX
	timer_basic_gun_level2 = timer_basic_gun_level2_MAX
	timer_side_laser = timer_side_laser_MAX
	timer_drill_level0 = timer_drill_level0_MAX
	timer_drill_level1 = timer_drill_level1_MAX
	timer_drill_level2 = timer_drill_level2_MAX
	timer_cannon_level0 = timer_cannon_level0_MAX
	timer_cannon_level1 = timer_cannon_level1_MAX
	timer_cannon_level2 = timer_cannon_level2_MAX

func update_timers(delta):
	for i in range(0, timer_fires.size()):
		timer_fires[i] = false
		
	# This is where I wish Godot had macros...
	# Although I guess we could use a class or the built-in timer or whatever
	timer_basic_gun_level0 -= delta
	if timer_basic_gun_level0 <= 0:
		timer_basic_gun_level0 += timer_basic_gun_level0_MAX
		timer_fires[TIMER_BASIC_GUN_LEVEL_0] = true
		
	timer_basic_gun_level1 -= delta
	if timer_basic_gun_level1 <= 0:
		timer_basic_gun_level1 += timer_basic_gun_level1_MAX
		timer_fires[TIMER_BASIC_GUN_LEVEL_1] = true
		
	timer_basic_gun_level2 -= delta
	if timer_basic_gun_level2 <= 0:
		timer_basic_gun_level2 += timer_basic_gun_level2_MAX
		timer_fires[TIMER_BASIC_GUN_LEVEL_2] = true
		
	timer_side_laser -= delta
	if timer_side_laser <= 0:
		timer_side_laser += timer_side_laser_MAX
		timer_fires[TIMER_SIDE_LASER] = true
		
	timer_drill_level0 -= delta
	if timer_drill_level0 <= 0:
		timer_drill_level0 += timer_drill_level0_MAX
		timer_fires[TIMER_DRILL_LEVEL_0] = true
		
	timer_drill_level1 -= delta
	if timer_drill_level1 <= 0:
		timer_drill_level1 += timer_drill_level1_MAX
		timer_fires[TIMER_DRILL_LEVEL_1] = true
		
	timer_drill_level2 -= delta
	if timer_drill_level2 <= 0:
		timer_drill_level2 += timer_drill_level2_MAX
		timer_fires[TIMER_DRILL_LEVEL_2] = true
		
	timer_cannon_level0 -= delta
	if timer_cannon_level0 <= 0:
		timer_cannon_level0 += timer_cannon_level0_MAX
		timer_fires[TIMER_CANNON_LEVEL_0] = true
		
	timer_cannon_level1 -= delta
	if timer_cannon_level1 <= 0:
		timer_cannon_level1 += timer_cannon_level1_MAX
		timer_fires[TIMER_CANNON_LEVEL_1] = true
		
	timer_cannon_level2 -= delta
	if timer_cannon_level2 <= 0:
		timer_cannon_level2 += timer_cannon_level2_MAX
		timer_fires[TIMER_CANNON_LEVEL_2] = true

const SHIP_BASIC_GUN = 0
const SHIP_SIDE_LASER = 1
const SHIP_DRILL = 2
const SHIP_CANNON = 3

class Upgrades:
	var left_path
	var right_path
	
	func _init(left_path_, right_path_):
		self.left_path = left_path_
		self.right_path = right_path_

class Upgrade:
	var cost
	var description
	
	func _init(cost_, description_):
		self.cost = cost_
		self.description = description_

# An array of all the PackedScenes corresponding to the SHIP_
# constants.
var ship_scenes = [
	preload("res://towers/BasicGun.tscn"),
	preload("res://towers/SideLaser.tscn"),
	preload("res://towers/Drill.tscn"),
	preload("res://towers/Cannon.tscn"),
	preload("res://towers/NanobotShooter.tscn"),
]

# The number of each kind of ship (SHIP_) that exists right now.
# Used to determine the price for more ships.
var ship_counts = [0, 0, 0, 0, 0, 0]

# An array of all upgrade information corresponding to the SHIP_
# constants.
var upgrades = [
	# Basic gun
	Upgrades.new(
	[
		Upgrade.new(200, "Increase the fire rate of this gunner by 1.2x."),
		Upgrade.new(300, "Increase the fire rate of this gunner by another 1.2x.")
	],
	[
		Upgrade.new(350, "Increase this gunner's piercing ability to 2."),
		Upgrade.new(500, "Increase this gunner's piercing ability to 3.")
	]),
	
	# Side laser
	Upgrades.new(
		[
			Upgrade.new(250, "Increase this laser's movement speed by 1.2x."),
			Upgrade.new(350, "Increase this laser's movement speed by another 1.2x.")
		],
		[
			Upgrade.new(2500, "Increase this laser's piercing ability to 2."),
			Upgrade.new(4000, "Increase this laser's piercing ability to 3.")
		]
	),
	
	# Drill
	Upgrades.new(
		[
			Upgrade.new(1200, "The drill will attack 1.5x as often."),
			Upgrade.new(1800, "The drill will attack another 2x as often.")
		],
		[
			Upgrade.new(1400, "Increase the drill's movement speed by 2.5x."),
			Upgrade.new(1500, "Increase the drill's movement speed by another 1.5x.")
		]	
	),
	
	# Cannon
	Upgrades.new(
		[
			Upgrade.new(600, "Increase the fire rate of the cannon by 1.1x"),
			Upgrade.new(800, "Increase the fire rate of the cannon by another 1.2x")
		],
		[
			Upgrade.new(1000, "Make this cannon's explosions 20% larger"),
			Upgrade.new(1200, "Make this cannon's explosions another 20% larger")
		]
	),
	
	# Nanobot shooter
	Upgrades.new(
		[
			Upgrade.new(200, "Make this ship shoot less sporadically."),
			Upgrade.new(700, "Make this ship shoot even less sporadically.")
		],
		[
			Upgrade.new(450, "This ship will impede virus growth by +1 more generation."),
			Upgrade.new(3400, "This ship will impede virus growth by +3 more generations.")
		]
	)
]

var Virus = preload("res://virus/Virus.tscn")
var VirusDebris = preload("res://virus/VirusDebris.tscn")

var BasicBullet = preload("res://towers/BasicBullet.tscn")
var SideLaserBullet = preload("res://towers/SideLaserBullet.tscn")
var Missile = preload("res://towers/Missile.tscn")
var Nanobot = preload("res://towers/Nanobot.tscn")

var Game = preload("res://Game.tscn")
var MainMenu = preload("res://MainMenu.tscn")

var Explosions = [
	preload("res://towers/MissileExplosion0.tscn"),
	preload("res://towers/MissileExplosion1.tscn"),
	preload("res://towers/MissileExplosion2.tscn"),
]

var game_camera: Camera2D = null

# These variables are used so that ships can coordinate who should be selected,
# when a tap overlaps multiple ships.
var selected_ship_map: Dictionary
var selected_ship_distance: Dictionary

# The upgrade target ship is always simply set to the previously
# selected ship.
var upgrade_target_ship: Node2D = null

# Whether the upgrade icon should be shown. Based on the menu state.
var show_upgrade_icon = false

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

# The node that newly bought ships should be parented to.
var ship_parent_node: Node2D = null

# Resets all the values in GS that are relevant to starting a game.
# It's sort of like rebooting the game.
#
# In fact, most values should only be written here, so that they can't get out
# of sync. E.g. lives is set to 0 above, but 200 in here, as it should be.
func reset_game_state():
	game_camera = null
	
	money = 0
	lives = 200
	
	ship_parent_node = null
	
	# DEBUG MONEY:
	money = 30000
	
	reset_timers()
	
func _ready():
	reset_game_state()
	
func _physics_process(delta):
	# NOTE TO FUTURE SELF:
	# ALL code that checks timers in Towers MUST be written in physics_process.
	update_timers(delta)

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
