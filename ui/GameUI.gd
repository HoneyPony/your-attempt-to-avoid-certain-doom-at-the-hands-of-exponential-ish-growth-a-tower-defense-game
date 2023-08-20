extends Control

onready var money_counter = $Shop/Money
onready var lives_counter = $Shop/Lives

onready var shop_anim = $Shop/AnimationPlayer

onready var shop_tab_button = $Shop/ShopTab
onready var upgrade_tab_button = $Shop/UpgradesTab

onready var upgrade_panel = $Shop/Upgrades
onready var upgrade_err_panel = $Shop/Upgrades/UpgradeErrPanel

onready var upgrade_ship_icon = $Shop/Upgrades/ShipIcon

onready var left_upgrade_card = $Shop/Upgrades/LeftUpgradeCard
onready var right_upgrade_card = $Shop/Upgrades/RightUpgradeCard

onready var sell_cost_label = $Shop/Upgrades/SellCostLabel
onready var sell_button = $Shop/Upgrades/SellButton

onready var shop_info = $Shop/ShopInfo

# This is really whether the bottom panel is open at all.
# Should match the starting state of the shop_anim AnimationPlayer.
var shop_open = false

func _ready():
	# Show the shop to begin
	update_tabs(false)
	
	left_upgrade_card.buy_button.connect("pressed", self, "buy_left_upgrade")
	right_upgrade_card.buy_button.connect("pressed", self, "buy_right_upgrade")
	
	# Get the ship parent node for ShipBuyers to use.
	GS.ship_parent_node = $"../../"
	
func buy_left_upgrade():
	var ship: TowerBase = GS.upgrade_target_ship as TowerBase
	if not is_instance_valid(ship):
		# The theory is this shouldn't be called.
		print("warning: trying to upgrade invalid ship")
		return
		
	var upgrades = GS.upgrades[ship.ship_type]
	
	if ship.left_level >= upgrades.left_path.size():
		# This shouldn't happen, but apparently does...?
		print("warning: cannot buy another left upgrade!")
		return
	
	var up = upgrades.left_path[ship.left_level]
	
	if up.cost > GS.money:
		# This also shouldn't happen due to the disable
		print("warning: trying to buy upgrade without enough money")
		return
		
	# Pay the cost
	GS.money -= up.cost
	# Upgrade the ship
	ship.left_level += 1
	
	Sounds.click1()
	
	
func buy_right_upgrade():
	var ship: TowerBase = GS.upgrade_target_ship as TowerBase
	if not is_instance_valid(ship):
		# The theory is this shouldn't be called.
		print("warning: trying to upgrade invalid ship")
		return
		
	var upgrades = GS.upgrades[ship.ship_type]
	
	if ship.right_level >= upgrades.right_path.size():
		print("warning: cannot buy another left upgrade!")
		return
	
	var up = upgrades.right_path[ship.right_level]
	
	if up.cost > GS.money:
		# This also shouldn't happen due to the disable
		print("warning: trying to buy upgrade without enough money")
		return
		
	# Pay the cost
	GS.money -= up.cost
	# Upgrade the ship
	ship.right_level += 1
	
	Sounds.click1()
	
func compute_sell_value(ship: TowerBase):
	return int(GS.compute_ship_cost(ship) * 0.8)
	
func compute_upgrade_cards(ship: TowerBase):
	upgrade_ship_icon.texture = GS.ship_icons[ship.ship_type]
	
	var sell_value = compute_sell_value(ship)
	sell_cost_label.text = str("You may sell\nthis ship for\n$", sell_value)	
	
	var upgrades = GS.upgrades[ship.ship_type]
	if ship.left_level >= upgrades.left_path.size():
		left_upgrade_card.full.show()
	else:
		left_upgrade_card.full.hide()
		
		var up = upgrades.left_path[ship.left_level]
		
		left_upgrade_card.desc.text = up.description
		left_upgrade_card.cost.text = str("Cost: $", up.cost)
		left_upgrade_card.buy_button.disabled = (up.cost > GS.money)


	if ship.right_level >= upgrades.right_path.size():
		right_upgrade_card.full.show()
	else:
		right_upgrade_card.full.hide()
		
		var up = upgrades.right_path[ship.right_level]
		
		right_upgrade_card.desc.text = up.description
		right_upgrade_card.cost.text = str("Cost: $", up.cost)
		right_upgrade_card.buy_button.disabled = (up.cost > GS.money)

	if get_tree().paused:
		left_upgrade_card.buy_button.disabled = true
		right_upgrade_card.buy_button.disabled = true
		sell_button.disabled = true
	else:
		sell_button.disabled = false

func _process(delta):
	money_counter.text = str("$ ", GS.money)
	lives_counter.text = str(GS.lives)
	
	# Show the upgrade icon if the upgrade panel is visible.
	GS.show_upgrade_icon = (shop_open and upgrade_panel.visible)
	# Show an error message if no ship is selected.
	upgrade_err_panel.visible = not is_instance_valid(GS.upgrade_target_ship)
	
	# Right now this recomputes the upgrades every frame... should be fine
	# hopefully
	if is_instance_valid(GS.upgrade_target_ship) and GS.show_upgrade_icon:
		compute_upgrade_cards(GS.upgrade_target_ship)

func _on_CloseButton_pressed():
	if shop_open:
		shop_anim.play("HideShop")
		shop_info.dismiss()
	else:
		shop_anim.play("ShowShop")
	shop_open = not shop_open
	
	Sounds.click1()
	
func update_tabs(show_upgrades: bool):
	shop_tab_button.pressed = not show_upgrades
	shop_tab_button.disabled = not show_upgrades
	
	upgrade_tab_button.pressed = show_upgrades
	upgrade_tab_button.pressed = show_upgrades
	
	upgrade_panel.visible = show_upgrades

func _on_ShopTab_toggled(button_pressed):
	update_tabs(not button_pressed)
	Sounds.click1()


func _on_UpgradesTab_toggled(button_pressed):
	update_tabs(button_pressed)
	Sounds.click1()


func _on_PauseButton_pressed():
	get_tree().paused = not get_tree().paused
	Sounds.click1()


func _on_SellButton_pressed():
	if is_instance_valid(GS.upgrade_target_ship):
		var total_value = GS.compute_ship_cost(GS.upgrade_target_ship)
		var sell_value = compute_sell_value(GS.upgrade_target_ship)
		
		GS.upgrade_target_ship.destroy()
		GS.money += sell_value
		
		# Also give back a tiny bit of the easyness, or whatever
		#
		# Basically -- if we do nothing, than the actual amount of money
		# the user has access to after selling is LESS than the amount of
		# money used for determining game progress.
		#
		# In particular, it is less by the exact amount (total_value - sell_value)
		#
		# So, we can refund a little bit of that to the game progress, to make the
		# game more fair.
		var refund = (total_value - sell_value) * 0.25
		GS.total_money -= refund
		
		Sounds.click1()
