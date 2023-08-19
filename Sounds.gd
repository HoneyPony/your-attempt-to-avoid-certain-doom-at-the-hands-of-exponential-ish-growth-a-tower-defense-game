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
#var basic_gun_shoots_i = 0

func basic_shoot(left_level):
	basic_gun_shoots[left_level].play_sfx()
	#basic_gun_shoots_i = (basic_gun_shoots_i + 1) % basic_gun_shoots.size()

func _ready():
	for d in destroys:
		d.volume_db = -8

func play_destroy():
	var i = randi() % destroys.size()
	destroys[i].play()

func click1():
	$UIClick1.play_sfx()

func click2():
	$UIClick2.play_sfx()
