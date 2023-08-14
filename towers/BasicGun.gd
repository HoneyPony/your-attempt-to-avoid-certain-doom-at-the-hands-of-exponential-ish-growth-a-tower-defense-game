extends Area2D

var fire_timer = 0
var fire_timer_max = 0.8

func _ready():
	fire_timer = fire_timer_max

func fire():
	var bullet = GS.BasicBullet.instance()
	bullet.position = position
	get_parent().add_child(bullet)
	


func _physics_process(delta):
	fire_timer -= delta
	if fire_timer <= 0:
		fire_timer = fire_timer_max
		fire()
		
	#if Input.is_mouse_button_pressed(BUTTON_LEFT)


enum DragState {
	NOT_DRAGGING,
	DRAG_MOUSE,
	DRAG_TOUCH
}

# Keeps track of how the current gun is being dragged, if at all.
# Dragging with the mouse and with the touch screen are considered
# mutually exclusive for simplicity.
var drag_state = DragState.NOT_DRAGGING

# The touch index associated with DragState.DRAG_TOUCH, if relevant.
# This allows us to move different towers with different fingers.
var drag_touch_index = 0

# Only activate dragging states through inputs that occur on this Area2D.
func _on_BasicGun_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				drag_state = DragState.DRAG_MOUSE
	
	if event is InputEventScreenTouch:
		if event.pressed:
			drag_state = DragState.DRAG_TOUCH
			drag_touch_index = event.index
				
				
func _input(event):
	# Dragging states may be deactivated by any input event.
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if drag_state == DragState.DRAG_MOUSE:
				drag_state = DragState.NOT_DRAGGING
	
	if event is InputEventScreenTouch:
		if drag_state == DragState.DRAG_TOUCH and not event.pressed:
			drag_state = DragState.NOT_DRAGGING
	
	if drag_state == DragState.DRAG_MOUSE:
		if event is InputEventMouseMotion:
			position += event.relative
	elif drag_state == DragState.DRAG_TOUCH:
		if event is InputEventScreenDrag and event.index == drag_touch_index:
			position += event.relative
