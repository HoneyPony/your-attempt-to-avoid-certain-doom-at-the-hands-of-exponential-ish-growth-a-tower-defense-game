extends Control

onready var money_counter = $Shop/Money
onready var lives_counter = $Shop/Lives

onready var shop_anim = $Shop/AnimationPlayer

var shop_open = true

func _process(delta):
	money_counter.text = str("$ ", GS.money)
	lives_counter.text = str(GS.lives)


func _on_CloseButton_pressed():
	if shop_open:
		shop_anim.play("HideShop")
	else:
		shop_anim.play("ShowShop")
	shop_open = not shop_open
