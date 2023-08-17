extends TextureRect

export var cost: int = 50

# Should match one of the SHIP_ constants in GS.
export var ship_id: int = 0

onready var buy_button = $BuyButton

func _ready():
	$CostLabel.text = str(cost)
	
func _process(delta):
	buy_button.disabled = (GS.money < cost)


func _on_BuyButton_pressed():
	if GS.money < cost:
		print("warning: tried to buy a ship without enough money.")
		return
		
	# Pay the cost
	GS.money -= cost
	
	var ship_tscn: PackedScene = GS.ship_scenes[ship_id]
	var ship = ship_tscn.instance()
	
	ship.position = Vector2.ZERO
	GS.ship_parent_node.add_child(ship)
