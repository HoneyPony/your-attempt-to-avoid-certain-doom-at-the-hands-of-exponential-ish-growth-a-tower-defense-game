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

onready var side_laser_shoot = $SideLaser


func basic_shoot(left_level):
	basic_gun_shoots[left_level].play_sfx()
	#basic_gun_shoots_i = (basic_gun_shoots_i + 1) % basic_gun_shoots.size()

func _ready():
	for d in destroys:
		d.volume_db = -8

func update_playing(sound: AudioStreamPlayer, should_playing: bool):
	if sound.playing != should_playing:
		sound.playing = should_playing

# Physics process for frame resets because that's when the
# sound effects are often triggered
func _physics_process(delta):
	update_playing(side_laser_shoot, GS.ship_counts[GS.SHIP_SIDE_LASER] > 0)

func play_destroy():
	var i = randi() % destroys.size()
	destroys[i].play()

func click1():
	$UIClick1.play_sfx()

func click2():
	$UIClick2.play_sfx()
