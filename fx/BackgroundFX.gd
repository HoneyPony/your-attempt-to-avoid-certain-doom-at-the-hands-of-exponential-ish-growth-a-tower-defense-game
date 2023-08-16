extends Sprite

var speed = 1 # 1 pixel per second

const ROTATE_BOUNDARY = 3000 # Not too significant...

func _process(delta):
	position.x += speed * delta
	
	# This "seems" to work... may warrant more testing
	if position.x > ROTATE_BOUNDARY:
		global_position.x = $Helper.global_position.x
	
