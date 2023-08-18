extends Panel

# How many pages we want to have read
var target_index = 0
# How many pages we have read
var read_index = -1

# If two messages do end up being opened consecutively, we delay them by a
# small amount.
var page_turn_delay = 0

onready var msgs = [
	$MSG_Welcome,
	$MSG_Upgrade,
	$MSG_Intel,
	$MSG_Intel2
]

func wants_to_open():
	return (not visible) and (target_index > read_index)

onready var anim = $AnimationPlayer

func _on_Dismiss_pressed():
	anim.play("Close")
	read_index += 1
	page_turn_delay = 0.4
	
func open():
	var next = read_index + 1
	for m in msgs:
		m.visible = false
	if next < msgs.size():
		msgs[next].visible = true
		anim.play("Open")
	
	
func _process(delta):
	if page_turn_delay > 0:
		page_turn_delay -= delta
	elif wants_to_open():
		open()
