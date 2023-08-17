extends StaticBody2D

export var lifetime = 0.8
var alive_frames = 0

func _ready():
	$CPUParticles2D.emitting = true

func _physics_process(delta):
	alive_frames += 1
	if alive_frames > 3:
		# Stop hitting new enemies pretty soon... just let the particle
		# effect continue
		collision_layer = 0
	
	lifetime -= delta
	if lifetime < 0:
		queue_free()

# We don't have to do anything when we hit something, but we do
# need this method to be defined.
func hit_something():
	pass
