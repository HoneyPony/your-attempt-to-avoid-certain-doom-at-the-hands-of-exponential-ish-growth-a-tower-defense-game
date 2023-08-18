extends Panel
class_name ShopInfo

onready var anim = $AnimationPlayer
onready var icon_rect = $ShipIcon

onready var infos = [
	$Ship0,
	$Ship1,
	$Ship2,
	$Ship3,
	$Ship4,
	$Ship5,
]

func open(new_button: Button, index: int, icon: Texture):
	if GS.current_shop_info_button != null:
		# Make sure the button doesn't try to dismiss.
		var b = GS.current_shop_info_button
		GS.current_shop_info_button = null
		b.pressed = false
		
	GS.current_shop_info_button = new_button
	
	icon_rect.texture = icon
	
	for info in infos:
		info.hide()
	infos[index].show()
	
	# If we're already open, don't re-play the animation.
	if not visible:
		anim.play("Open")
		
func dismiss():
	if GS.current_shop_info_button:
		# Make sure the button doesn't try to re-dismiss.
		var b = GS.current_shop_info_button
		GS.current_shop_info_button = null
		b.pressed = false
	
	anim.play("Close")


func _on_Dismiss_pressed():
	dismiss()
