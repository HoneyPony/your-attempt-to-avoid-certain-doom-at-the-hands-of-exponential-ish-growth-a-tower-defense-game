extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("test_spawn"):
		var vc = GS.VirusCollection.instance()
		vc.spawn_timer_max = 0.3
		vc.position.y = -1280
		vc.position.x = rand_range(-20, 20)
		vc.priming_count = 15
		add_child(vc)
