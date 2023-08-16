extends TextureRect

export var cost: int = 50

onready var buy_button = $BuyButton

func _ready():
	$CostLabel.text = str("Cost: $", cost)
	
func _process(delta):
	buy_button.disabled = (GS.money < cost)
