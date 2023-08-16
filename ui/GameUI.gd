extends Control

onready var money_counter = $Shop/Money
onready var lives_counter = $Shop/Lives

onready var shop_anim = $Shop/AnimationPlayer

onready var shop_tab_button = $Shop/ShopTab
onready var upgrade_tab_button = $Shop/UpgradesTab

onready var upgrade_panel = $Shop/Upgrades

# This is really whether the bottom panel is open at all.
# Should match the starting state of the shop_anim AnimationPlayer.
var shop_open = false

func _ready():
	# Show the shop to begin
	update_tabs(false)

func _process(delta):
	money_counter.text = str("$ ", GS.money)
	lives_counter.text = str(GS.lives)


func _on_CloseButton_pressed():
	if shop_open:
		shop_anim.play("HideShop")
	else:
		shop_anim.play("ShowShop")
	shop_open = not shop_open
	
func update_tabs(show_upgrades: bool):
	shop_tab_button.pressed = not show_upgrades
	shop_tab_button.disabled = not show_upgrades
	
	upgrade_tab_button.pressed = show_upgrades
	upgrade_tab_button.pressed = show_upgrades
	
	upgrade_panel.visible = show_upgrades

func _on_ShopTab_toggled(button_pressed):
	update_tabs(not button_pressed)


func _on_UpgradesTab_toggled(button_pressed):
	update_tabs(button_pressed)
