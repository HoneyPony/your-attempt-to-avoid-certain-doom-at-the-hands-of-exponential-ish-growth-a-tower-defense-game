extends Node2D

var lifetime = 5

func set_color(color: Color):
	$Particles1.color = color
	
func _ready():
	$Particles1.emitting = true
	$Particles2.emitting = true

func _process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()
