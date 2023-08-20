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

onready var missile_shoots = [
	$Missile1,
	$Missile2,
	$Missile3
]

onready var missile_explodes = [
	$Explode1,
	$Explode2,
	$Explode3,
	$Explode4,
	$Explode5,
]
var missile_explode_i = 0
#var basic_gun_shoots_i = 0

onready var side_laser_shoot = $SideLaser
onready var drill = $Drill
onready var blip1_fx = $Blip1

func win():
	$Win.play()
func lose():
	$Lose.play()

func blip1():
	blip1_fx.play_sfx()

func basic_shoot(left_level):
	basic_gun_shoots[left_level].play_sfx()
	#basic_gun_shoots_i = (basic_gun_shoots_i + 1) % basic_gun_shoots.size()

func kinetic_shoot(index_0_1):
	kinetic_shoots[index_0_1].play_sfx()

func nano_shoot():
	nano_bot_shoots[nano_bot_shoots_i].play_sfx()
	nano_bot_shoots_i = (nano_bot_shoots_i + 1) % nano_bot_shoots.size()

func cannon_shoot(left_level):
	missile_shoots[left_level].play_sfx()
	
func missile_explode():
	missile_explodes[missile_explode_i].play_sfx()
	missile_explode_i = (missile_explode_i + 1) % missile_explodes.size()

func _ready():
	for d in destroys:
		d.volume_db = -8
		
	$MUSIC.play()

func update_playing(sound: AudioStreamPlayer, should_playing: bool):
	if sound.playing != should_playing:
		sound.playing = should_playing

func does_there_exist_a_firing_side_laser():
	var sl = get_tree().get_nodes_in_group("SideLaser")
	for s in sl:
		if s.state == TowerBase.State.NORMAL:
			return true
	return false

func does_there_exist_an_active_drill():
	var drills = get_tree().get_nodes_in_group("Drill")
	for d in drills:
		if d.state == TowerBase.State.NORMAL:
			return true
	return false

# Physics process for frame resets because that's when the
# sound effects are often triggered
func _physics_process(delta):
	var should_side_laser_shoot: bool = does_there_exist_a_firing_side_laser()
	should_side_laser_shoot = should_side_laser_shoot and not get_tree().paused
	update_playing(side_laser_shoot, should_side_laser_shoot)

	var should_drill: bool = does_there_exist_an_active_drill()
	should_drill = should_drill and not get_tree().paused
	update_playing(drill, should_drill)

func play_destroy():
	var i = randi() % destroys.size()
	destroys[i].play()

func click1():
	$UIClick1.play_sfx()

func click2():
	$UIClick2.play_sfx()
