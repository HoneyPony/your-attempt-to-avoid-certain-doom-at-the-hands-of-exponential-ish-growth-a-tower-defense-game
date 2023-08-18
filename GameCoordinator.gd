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
		vc.spawn_timer_max = 4.0
		vc.position.y = -1280
		# Weaker cluster
		vc.get_node("Virus").generation = 7
		vc.get_node("Virus").set_hue()
		# absolute maximum bounds for srength = 18
		#vc.position.x = rand_range(-144, 144)
		vc.position.x = rand_range(-100, 100)
		vc.priming_count = 4
		add_child(vc)
