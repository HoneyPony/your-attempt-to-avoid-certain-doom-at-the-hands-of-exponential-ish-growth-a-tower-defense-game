extends "res://towers/BulletBase.gd"

var velocity = Vector2.ZERO

onready var front = $Front
onready var end = $End

var next = null
var prev = null

func render_lines():
	var front_target = Vector2(-59, 0)
	if is_instance_valid(prev):
		var to = prev.end.global_position
		var from = front.global_position
		front_target = (to - from) * 0.5

	var end_target = Vector2(53, 0)
	if is_instance_valid(next):
		var to = next.front.global_position
		var from = end.global_position
		end_target = (to - from) * 0.5
		
	#front.points[1] += (front_target - front.points[1]) * 0.09
	#end.points[1] += (end_target - end.points[1]) * 0.09
		
	front.points[1] += (front_target - front.points[1]) * 1
	end.points[1] += (end_target - end.points[1]) * 1
	
func _process(delta):
	render_lines()

func _physics_process(delta):
	# Side laser bullets are very very very simple.
	# The only important thing is computing the correct velocity to match
	# the laser firing speed.
	move_and_slide(velocity)
