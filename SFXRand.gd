extends AudioStreamPlayer

var start_db
var start_pitch

export var range_min = 0.95
export var range_max = 1.04

func _ready():
	start_db = volume_db
	start_pitch = pitch_scale 

func play_usual():
	
	play()

func play_sfx():
	
	#volume_db = start_db + rand_range(-0.05, 0.05)
	pitch_scale = start_pitch * rand_range(range_min, range_max)
	
	play()
