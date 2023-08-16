extends Control

onready var money_counter = $Money
onready var lives_counter = $Lives

func _process(delta):
	money_counter.text = str("$ ", GS.money)
	lives_counter.text = str(GS.lives)
