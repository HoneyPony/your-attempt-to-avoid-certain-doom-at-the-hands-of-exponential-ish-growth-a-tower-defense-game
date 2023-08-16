extends Node

var Virus = preload("res://virus/Virus.tscn")
var VirusDebris = preload("res://virus/VirusDebris.tscn")

var BasicBullet = preload("res://towers/BasicBullet.tscn")

var game_camera: Camera2D

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
