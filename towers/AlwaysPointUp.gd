# Simple script so that the attached thing always points up (/ doesn't rotate),
# e.g. for the BasicGun's cannon.
extends Node2D

func _process(delta):
	global_rotation = 0
