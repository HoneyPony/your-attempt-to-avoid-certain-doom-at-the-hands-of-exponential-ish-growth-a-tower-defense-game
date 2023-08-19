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

func play_destroy():
	var i = randi() % destroys.size()
	destroys[i].play()
