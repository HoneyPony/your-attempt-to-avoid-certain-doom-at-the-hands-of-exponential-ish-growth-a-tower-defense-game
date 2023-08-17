extends Area2D
class_name TowerBase

var velocity: Vector2 = Vector2.ZERO
export var acceleration_strength = 1000
export var movement_speed = 256

# Should correspond to one of the SHIP_ constants in GS
export var ship_type = 0

# Upgrade levels -- the ship has to compute what these mean.
var left_level = 0
var right_level = 0

# I guess, most towers will have a ship sprite
onready var ship_sprite = $ShipSprite

# All towers should have the movement display
onready var movement_display: Line2D = $MovementDisplay

# Bounds so that ships always stay on screen
const MAX_X = 700
const MAX_Y = 1250

func bound_ship_position(pos: Vector2) -> Vector2:
	pos.x = clamp(pos.x, -MAX_X, MAX_X)
	pos.y = clamp(pos.y, -MAX_Y, MAX_Y)
	return pos

func update_movement_display():
	var end = (drag_target_position - position)
	
	if end.length_squared() < 16 * 16 * 4 * 4:
		movement_display.visible = false
		# Don't even bother computing the points if it won't be visible
		return
		
	var alpha = end.length() / (1024)
	alpha = clamp(alpha, 0, 1)
	
	movement_display.modulate.a = alpha * 0.4
		
	movement_display.visible = true
	
	# We have more than 2 points so that we can use the width curve
	var N = movement_display.points.size()
	for i in range(0, N):
		var t = (i / float(N - 1))
		
		movement_display.points[i] = end * t

func _ready():
	drag_target_position = position

func compute_acceleration(desired_velocity: Vector2, delta: float, zero_threshold: float = 0.0) -> Vector2:
	var accel_direction = (desired_velocity - velocity).normalized()
	
	var delta_accel_strength = acceleration_strength * delta
	
	var max_acceleration = (desired_velocity - velocity).length()
	var actual_accel_amount = min(max_acceleration, delta_accel_strength)
	
	return accel_direction * actual_accel_amount
	
func perform_physics(delta):
	var target_point = drag_target_position
	
	var direction_vector = (target_point - global_position)
	var distance = direction_vector.length()
	var desired_velocity: Vector2 = direction_vector.normalized() * movement_speed
	
	# This is a nice bit of physics to calculate when we should be decelerating
	# based on our current velocity, in order to reach the target position right
	# on time.
	var position_boundary_for_deceleration = velocity.length_squared() / acceleration_strength
	
	var should_be_decelerating = distance < position_boundary_for_deceleration
	
	if should_be_decelerating:
		var acceleration: Vector2 = -velocity.normalized() * acceleration_strength
		acceleration *= delta
		
		var max_acceleration = velocity.length()
		if acceleration.length() > max_acceleration:
			acceleration = acceleration.normalized() * max_acceleration
			
		velocity += acceleration # already multiplied by delta
		if velocity.length_squared() < 0.5 * 0.5:
			velocity = Vector2.ZERO
	else:
		var acceleration: Vector2 = compute_acceleration(desired_velocity, delta)	
		velocity += acceleration
	
	#move_and_slide(velocity)
	position += velocity * delta

func _physics_process(delta):
	perform_physics(delta)
	
	position = bound_ship_position(position)
	
	update_movement_display()

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

# Used to ensure that we get consistent results for our "springyness"
# while still dragging.
var drag_target_position: Vector2 = Vector2.ZERO

func tform_drag_pos(pos: Vector2) -> Vector2:
	return GS.game_camera.to_global(pos * GS.game_camera.zoom)

func try_to_grab_drag(touch_index: int, event_pos: Vector2) -> bool:
	var distance = (position - tform_drag_pos(event_pos)).length_squared()
	return GS.try_grab_selection(self, touch_index, distance)

const MOUSE_TOUCH_INDEX = -1

# Only activate dragging states through inputs that occur on this Area2D.
func _on_BasicGun_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				if try_to_grab_drag(MOUSE_TOUCH_INDEX, event.position):
					# Must deselect in case we were already dragging
					drag_state = DragState.DRAG_MOUSE
					# This MUST be updated for deselect()
					drag_touch_index = MOUSE_TOUCH_INDEX
					#drag_target_position = position
					drag_offset = position - tform_drag_pos(event.position)
	
					# We are now the upgrade target
					GS.upgrade_target_ship = self
	
	if event is InputEventScreenTouch:
		if event.pressed:
			if try_to_grab_drag(event.index, event.position):
				# Must deselect in case we were already dragging
				deselect()
				
				drag_state = DragState.DRAG_TOUCH
				drag_touch_index = event.index
				#drag_target_position = position
				drag_offset = position - tform_drag_pos(event.position)
				
				# We are now the upgrade target
				GS.upgrade_target_ship = self
				
		
func deselect():
	drag_state = DragState.NOT_DRAGGING
	
	# If we are currently owning this drag event, or whatever, give it up
	if GS.selected_ship_map.get(drag_touch_index) == self:
		GS.selected_ship_map[drag_touch_index] = null
				
func _input(event):
	# Dragging states may be deactivated by any input event.
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if drag_state == DragState.DRAG_MOUSE:
				deselect()
	
	if event is InputEventScreenTouch and event.index == drag_touch_index:
		if drag_state == DragState.DRAG_TOUCH and not event.pressed:
			deselect()
	
	if drag_state == DragState.DRAG_MOUSE:
		if event is InputEventMouseMotion:
			drag_target_position = tform_drag_pos(event.position) + drag_offset
			drag_target_position = bound_ship_position(drag_target_position)
			#drag_target_position = position
			#limit_y()
	elif drag_state == DragState.DRAG_TOUCH:
		if event is InputEventScreenDrag and event.index == drag_touch_index:
			drag_target_position = tform_drag_pos(event.position) + drag_offset
			drag_target_position = bound_ship_position(drag_target_position)
			#drag_target_position = position
			#limit_y()
