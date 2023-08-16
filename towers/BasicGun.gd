extends Area2D

var fire_timer = 0
var fire_timer_max = 0.7

var velocity: Vector2 = Vector2.ZERO
export var acceleration_strength = 1000
export var movement_speed = 256

onready var bullet_spawn_point = $BulletSpawnPoint
onready var movement_display: Line2D = $MovementDisplay

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
	fire_timer = fire_timer_max
	drag_target_position = position

func fire(delta):
	var bullet = GS.BasicBullet.instance()
	bullet.position = position + bullet_spawn_point.position + velocity * delta
	get_parent().add_child(bullet)
	
const SCREEN_END_Y = 1280

func limit_y_t(t: float) -> float:
	if t < 0:
		return t
	
	# What this does:
	# It takes a value of t = 4 to actually reach 1
	# But then we can't go past that.
	t = 0.25 * t
	#t = t * t
	if t > 1:
		return 1.0
	return t

func limit_y():
	var y_limit_soft = SCREEN_END_Y - 900
	var y_limit_hard = 0
	
	if position.y < y_limit_soft:
		var t = (position.y - y_limit_soft) / (y_limit_hard - y_limit_soft)
		t = limit_y_t(t)
		position.y = lerp(y_limit_soft, y_limit_hard, t)

onready var ship_sprite = $BasicGun
func ship_fx():
	ship_sprite.position.y = 8 * sin(Time.get_ticks_msec() / 1000.0)
	
	var rot_target = (velocity.x / movement_speed) * (TAU / 16.0)
	ship_sprite.rotation += (rot_target - ship_sprite.rotation) * 0.09

func compute_acceleration(desired_velocity: Vector2, delta: float, zero_threshold: float = 0.0) -> Vector2:
	var accel_direction = (desired_velocity - velocity).normalized()
	
	var delta_accel_strength = acceleration_strength * delta
	
#	if (desired_velocity - Vector2.ZERO).length_squared() <= zero_threshold * zero_threshold:
#		delta_accel_strength *= drift_acceleration_multiplier
#	elif desired_velocity.dot(velocity) < 0:
#		# Don't apply back-accel at same time as drift.
#		delta_accel_strength *= back_acceleration_multiplier
	
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
	
	fire_timer -= delta
	if fire_timer <= 0:
		fire_timer = fire_timer_max
		fire(delta)
		
	#if drag_state != DragState.NOT_DRAGGING:
	#	position = drag_target_position
		
	#limit_y()	
	ship_fx()
	update_movement_display()
	
		
#	var y_range = (position.y - (512 - max_range))
#	#print(y_range)
#	if y_range < 0:
#		var force = -y_range * 10
#		position.y += force * delta
		
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

# Used to ensure that we get consistent results for our "springyness"
# while still dragging.
var drag_target_position: Vector2 = Vector2.ZERO

func tform_drag_pos(pos: Vector2) -> Vector2:
	return GS.game_camera.to_global(pos * GS.game_camera.zoom)

# Only activate dragging states through inputs that occur on this Area2D.
func _on_BasicGun_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				drag_state = DragState.DRAG_MOUSE
				#drag_target_position = position
				drag_offset = position - tform_drag_pos(event.position)
	
	if event is InputEventScreenTouch:
		if event.pressed:
			drag_state = DragState.DRAG_TOUCH
			drag_touch_index = event.index
			#drag_target_position = position
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
			drag_target_position = tform_drag_pos(event.position) + drag_offset
			#drag_target_position = position
			#limit_y()
	elif drag_state == DragState.DRAG_TOUCH:
		if event is InputEventScreenDrag and event.index == drag_touch_index:
			drag_target_position = tform_drag_pos(event.position) + drag_offset
			#drag_target_position = position
			#limit_y()
