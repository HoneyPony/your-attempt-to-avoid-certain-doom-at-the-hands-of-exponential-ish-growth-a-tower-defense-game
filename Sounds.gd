extends Node

onready var destroys = [
	$Destroy1,
	$Destroy2,
	$Destroy3,
	$Destroy4,
	$Destroy5,
	$Destroy6,
	$Destroy7,
	$Destroy8,
	$Destroy9,
	$Destroy11,
	$Destroy12,
	$Destroy13,
	$Destroy14,
]

onready var basic_gun_shoots = [
	$Basic1,
	$Basic2,
	$Basic3
]

onready var nano_bot_shoots = [
	$Nano1,
	$Nano2,
	$Nano3,
	$Nano4,
	$Nano5,
	$Nano6,
]
var nano_bot_shoots_i = 0

onready var kinetic_shoots = [
	$Kinetic1,
	$Kinetic2
]
#var basic_gun_shoots_i = 0

onready var side_laser_shoot = $SideLaser


func basic_shoot(left_level):
	basic_gun_shoots[left_level].play_sfx()
	#basic_gun_shoots_i = (basic_gun_shoots_i + 1) % basic_gun_shoots.size()

func kinetic_shoot(index_0_1):
	kinetic_shoots[index_0_1].play_sfx()

func nano_shoot():
	nano_bot_shoots[nano_bot_shoots_i].play_sfx()
	nano_bot_shoots_i = (nano_bot_shoots_i + 1) % nano_bot_shoots.size()

func _ready():
	for d in destroys:
		d.volume_db = -8

func update_playing(sound: AudioStreamPlayer, should_playing: bool):
	if sound.playing != should_playing:
		sound.playing = should_playing

func does_there_exist_a_firing_side_laser():
	var sl = get_tree().get_nodes_in_group("SideLaser")
	for s in sl:
		if s.state == TowerBase.State.NORMAL:
			return true
	return false

# Physics process for frame resets because that's when the
# sound effects are often triggered
func _physics_process(delta):
	var should_side_laser_shoot: bool = does_there_exist_a_firing_side_laser()
	should_side_laser_shoot = should_side_laser_shoot and not get_tree().paused
	update_playing(side_laser_shoot, should_side_laser_shoot)

func play_destroy():
	var i = randi() % destroys.size()
	destroys[i].play()

func click1():
	$UIClick1.play_sfx()

func click2():
	$UIClick2.play_sfx()
