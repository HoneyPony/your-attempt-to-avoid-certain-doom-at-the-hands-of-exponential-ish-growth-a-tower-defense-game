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
		
	var y_range = (position.y - (512 - max_range))
	#print(y_range)
	if y_range < 0:
		var force = -y_range * 10
		position.y += force * delta
		
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

# How much the drag was offset by. This lets us use the global position
# to implement dragging, which is more flexible.
var drag_offset = Vector2.ZERO

# The maximum distance the user can drag this from the bottom of
# the screen. A springy force holds them back from dragging farther.
var max_range = 300

func tform_drag_pos(pos: Vector2) -> Vector2:
	return GS.game_camera.to_global(pos * GS.game_camera.zoom)

# Only activate dragging states through inputs that occur on this Area2D.
func _on_BasicGun_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				drag_state = DragState.DRAG_MOUSE
				drag_offset = position - tform_drag_pos(event.position)
	
	if event is InputEventScreenTouch:
		if event.pressed:
			drag_state = DragState.DRAG_TOUCH
			drag_touch_index = event.index
			drag_offset = position - tform_drag_pos(event.position)
				
				
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
			position = tform_drag_pos(event.position) + drag_offset
	elif drag_state == DragState.DRAG_TOUCH:
		if event is InputEventScreenDrag and event.index == drag_touch_index:
			position = tform_drag_pos(event.position) + drag_offset
			
