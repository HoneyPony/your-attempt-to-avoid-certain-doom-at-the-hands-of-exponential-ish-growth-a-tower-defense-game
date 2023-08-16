extends TextureRect

export var cost: int = 50

onready var buy_button = $BuyButton

func _ready():
	$CostLabel.text = str(cost)
	
func _process(delta):
	buy_button.disabled = (GS.money < cost)
