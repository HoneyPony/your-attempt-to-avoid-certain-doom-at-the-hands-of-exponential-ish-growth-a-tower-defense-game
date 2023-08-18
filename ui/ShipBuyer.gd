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
	
func _process(delta):
	update_actual_cost()
	buy_button.disabled = (GS.money < actual_cost)
	
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
	



func _on_InfoButton_toggled(button_pressed):
	if button_pressed:
		shop_info.open(info_button, ship_id, texture)
	else:
		if info_button == GS.current_shop_info_button:
			shop_info.dismiss()
