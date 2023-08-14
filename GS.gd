extends Node

var Virus = preload("res://virus/Virus.tscn")

var BasicBullet = preload("res://towers/BasicBullet.tscn")

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
