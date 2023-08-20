extends TextureRect

export var cost: int = 50
export var exponent: float = 1.5

var actual_cost: int = 0

# The maximum that the cost can ever reach.
const MAX_COST = 999999999

# Should match one of the SHIP_ constants in GS.
export var ship_id: int = 0

onready var buy_button = $BuyButton
onready var info_button = $InfoButton

onready var shop_info: ShopInfo = get_node("../../ShopInfo")

func _ready():
	update_actual_cost()
	GS.ship_buyers[ship_id] = self
	
func _process(delta):
	update_actual_cost()
	buy_button.disabled = (GS.money < actual_cost)
	
	if get_tree().paused:
		buy_button.disabled = true
	
#func get_delta_cost():
#	var cur_cost = int(pow(exponent, GS.ship_counts[ship_id]) * cost)
#	var last_cost = 0
#	if GS.ship_counts[ship_id] > 1:
#		last_cost =  int(pow(exponent, GS.ship_counts[ship_id] - 1) * cost)
#
#	return cur_cost - last_cost
	
func get_last_ship_cost():
	# This will only be called if we have at least 1 ship.
	# If we have at least 1 ship,t hen GS.ship_counts[] will be 1.
	# So, the lowest exponent is 0
	# So the lowest cost (when we have 1 ship) is the base cost,
	# as we would expect.
	return int(pow(exponent, GS.ship_counts[ship_id] - 1) * cost)
	
func update_actual_cost():
	# The actual cost is based on the exported base cost.
	actual_cost = int(pow(exponent, GS.ship_counts[ship_id]) * cost)
	if actual_cost > MAX_COST:
		actual_cost = MAX_COST
	$CostLabel.text = str("$", actual_cost)

func _on_BuyButton_pressed():
	# Make sure the cost value is computed before actually completeing
	# the purchase.
	update_actual_cost()
	
	if GS.money < actual_cost:
		print("warning: tried to buy a ship without enough money.")
		return
		
	# Pay the cost
	GS.money -= actual_cost
	
	var ship_tscn: PackedScene = GS.ship_scenes[ship_id]
	var ship = ship_tscn.instance()
	
	ship.position = Vector2.ZERO
	GS.ship_parent_node.add_child(ship)
	
	Sounds.click1()


func _on_InfoButton_toggled(button_pressed):
	if button_pressed:
		shop_info.open(info_button, ship_id, texture)
		Sounds.click1()
	else:
		if info_button == GS.current_shop_info_button:
			shop_info.dismiss()
			Sounds.click1()
