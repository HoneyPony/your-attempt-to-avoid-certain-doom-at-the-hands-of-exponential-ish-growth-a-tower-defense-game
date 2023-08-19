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
onready var side_laser_shoots = [
	$SideLaser,
	$SideLaser2,
	$SideLaser3
]
var side_laser_shoots_i = 0
# Only let this sound trigger once per frame, even though
# we provide polyphony.
var side_laser_per_frame = false

func basic_shoot(left_level):
	basic_gun_shoots[left_level].play_sfx()
	#basic_gun_shoots_i = (basic_gun_shoots_i + 1) % basic_gun_shoots.size()

func side_laser():
	if side_laser_per_frame:
		return
	side_laser_shoots[side_laser_shoots_i].play_usual()
	side_laser_shoots_i = (side_laser_shoots_i + 1) % side_laser_shoots.size()
	side_laser_per_frame = true

func _ready():
	for d in destroys:
		d.volume_db = -8

# Physics process for frame resets because that's when the
# sound effects are often triggered
func _physics_process(delta):
	side_laser_per_frame = false

func play_destroy():
	var i = randi() % destroys.size()
	destroys[i].play()

func click1():
	$UIClick1.play_sfx()

func click2():
	$UIClick2.play_sfx()
