extends Control

onready var money_counter = $Shop/Money
onready var lives_counter = $Shop/Lives

func _process(delta):
	money_counter.text = str("$ ", GS.money)
	lives_counter.text = str(GS.lives)
