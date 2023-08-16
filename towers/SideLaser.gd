extends "res://towers/TowerBase.gd"

const SIDE_LASER_POSITION = 654

var fire_timer = 0
var fire_timer_max = 0.3

onready var bullet_spawn_point = $BulletSpawnPoint

var prev_bullet = null

# Where bullets will connect to with line drawing.
onready var front = $Front

func _ready():
	fire_timer = fire_timer_max
	
func fire():
	var bullet = GS.SideLaserBullet.instance()
	bullet.position = bullet_spawn_point.global_position
	# May change when we add upgrades, etc
	# 360 is just enough to get to the edge of the screen with the default lifetime
	# of 4. We can change the lifetime of course, but this seems reasonable
	# for now.
	bullet.velocity = Vector2(-360, 0)
	get_parent().add_child(bullet)
	
	# By default, the "next" bullet in the chain is just ourselves. We need to
	# have a "front" member for this to work.
	bullet.next = self
	
	# Link the bullets together so they can render
	bullet.prev = prev_bullet
	if is_instance_valid(prev_bullet):
		# Turn off the straight tail that it had
		prev_bullet.next = bullet
	
	# Update this var so we can use it next time
	prev_bullet = bullet

func _physics_process(delta):
	# The side laser never moves from.. well.. the side.
	position.x = SIDE_LASER_POSITION
	
	fire_timer -= delta
	if fire_timer <= 0:
		fire_timer = fire_timer_max
		fire()
		
