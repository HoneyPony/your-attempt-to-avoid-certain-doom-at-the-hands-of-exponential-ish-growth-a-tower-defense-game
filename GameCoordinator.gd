extends Node2D

onready var tutorial = $CanvasLayer/GameUI/Tutorial

# Used to help make sure we spawn at least one Scary guy.
enum ScaryState {
	NOT_YET,
	WANT_TO_SPAWN,
	DONE
}

var flag_mandatory_scary = ScaryState.NOT_YET

func y_minimum():
	if GS.total_money <= 3000:
		return 32
	if GS.total_money <= 6000:
		return 300
	return 700

func check_y_prob():
	var vc = get_tree().get_nodes_in_group("VirusCollection")
	var y = 1280
	for v in vc:
		if v.position.y < y:
			y = v.position.y
			
	var probability = (y - (-1280.0 + y_minimum())) / (1280.0 * 2)
	#print(probability)
	# We are more likely to spawn if the other virus collections are far
	# down on screen. We can't even spawn at all if they're near the top.
	return randf() < probability

func try_to_spawn():
	# We can only have at most 2 virus collections at once.
	if get_tree().get_nodes_in_group("VirusCollection").size() >= 2:
		return
		
	# We can only have 1 scary virus collection.
	if get_tree().get_nodes_in_group("Scary").size() >= 1:
		return
		
	# We can't spawn while the tutorial is open
	if tutorial.visible:
		return
		
	# At certain checkpoints, we want to open a tutorial screen -- at that time,
	# no more probes are allowed to spawn.
	if tutorial.wants_to_open():
		return
		
	# Don't spawn much if there's already virus collections near the top of
	# the screen.
	if not check_y_prob():
		return
		
	# If we haven't bought a ship, don't let anything spawn.
	if not GS.has_any_ship():
		return
		
	if GS.total_money <= 2700:
		spawn_weak_vc()
	elif GS.total_money <= 6000:
		spawn_somewhat_weak_vc()
	elif GS.total_money <= 18000:
		spawn_level_3_vc()
	else:
		spawn_vc(0.3, 10)
	
# Spawns a virus collection that is "weak", i.e. the kind that you encounter
# right at the beginning of the game.
func spawn_weak_vc():
	# "Scare" virus collection -- fast moving and fast spawning,
	# but has a very low cap.
	var may_spawn_scary_rng = flag_mandatory_scary == ScaryState.DONE
	may_spawn_scary_rng = may_spawn_scary_rng and (GS.total_money >= 550 and GS.total_money <= 2300)
	var should_spawn = flag_mandatory_scary == ScaryState.WANT_TO_SPAWN
	should_spawn = should_spawn or (randf() < 0.5 and may_spawn_scary_rng)
	if should_spawn:
		#print("Scare!")
		flag_mandatory_scary = ScaryState.DONE
		var vc: Node2D = spawn_vc(rand_range(0.2, 0.4), 0, 9, 1.8, 13)
		vc.add_to_group("Scary")
		return
	
	# Maybe the maximum money that we would expect to be weak?
	var money_max = 3000.0
	# Where the weak things are completely weak.
	var money_min = 120.0
	
	var t = (GS.total_money - money_min) / (money_max - money_min)
	t = clamp(t, 0, 1)
	t = sqrt(t)
	
	print(t)
	
	var spawn_timer = lerp(4.0, 2.5, t)
	var generation = 0#ceil(lerp(, t))
	var prime = lerp(0, 7, t)
	prime = round(prime + rand_range(0, 2.5))
	
	var speed_mul = rand_range(0.9, 1.2)
	
	spawn_vc(spawn_timer, prime, generation, speed_mul)
	#print("Spanwed weak vC!")
	
func spawn_somewhat_weak_vc():
	var money_max = 6000.0
	var money_min = 3000.0
	
	if GS.total_money >= 3400 and GS.total_money <= 5500:
		# Scary
		if randf() < 0.5:
			#print("Scare!")
			var vc: Node2D = spawn_vc(rand_range(0.2, 0.4), 0, 7, 1.1, 13)
			vc.add_to_group("Scary")
			return
	
	var t = (GS.total_money - money_min) / (money_max - money_min)
	t = clamp(t, 0, 1)
	t = sqrt(t)
	#print("some: ", t)
	
	var spawn_timer = lerp(2.4, 1.5, t)
	var generation = ceil(lerp(3, 1, t))
	var prime = lerp(5, 15, t)
	prime = round(prime + rand_range(0, 5))
	
	var speed_mul = rand_range(0.95, 1.05)
	
	spawn_vc(spawn_timer, prime, generation, speed_mul)
	
func spawn_level_3_vc():
	var money_max = 12000.0
	var money_min = 6000.0
	
	var t = (GS.total_money - money_min) / (money_max - money_min)
	t = clamp(t, 0, 1)
	t = sqrt(t)
	
	var spawn_timer = lerp(1.5, 0.8, t)
	var generation = 0
	var prime = round(rand_range(40, 60))
	
	spawn_vc(spawn_timer, prime, generation)
	
# Formula for bounds:
# (1440 - (64 * generation)) / 2 gives approx bounds
func spawn_vc(spawn_timer, prime = 0, generation = 0, speed_mul = 1, max_strength = 18):
	var vc = GS.VirusCollection.instance()
	vc.spawn_timer_max = spawn_timer
	vc.position.y = -1280 - 32
	# Weaker cluster
	vc.get_node("Virus").generation = generation
	vc.get_node("Virus").set_hue()
	# absolute maximum bounds for srength = 18
	#vc.position.x = rand_range(-144, 144)
	var x = ((1440 - (64 * (max_strength - generation))) / 2 - 32)
	x = max(x, 0)
	vc.position.x = rand_range(-x, x)
	vc.priming_count = prime
	vc.actual_max_strength = max_strength
	add_child(vc)
	
	return vc
	
func try_open_tutorial(index):
	if tutorial.target_index < index:
		tutorial.target_index = index

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randf() < 0.5:
		# We try to spawn randomly.
		try_to_spawn()
	
	if Input.is_action_just_pressed("test_spawn"):
		pass
		
	# This is *total_money*, so it includes the initial 100 we start out with.
	if GS.total_money >= 150:
		try_open_tutorial(1)
		
	if GS.total_money >= 1500:
		try_open_tutorial(3)
		
	if GS.total_money >= 550:
		try_open_tutorial(2)
		flag_mandatory_scary = ScaryState.WANT_TO_SPAWN
		
	# Give player some big money even in somewhat_weka
	if GS.total_money >= 3300:
		GS.earned_money = 5
	if GS.total_money >= 7000:
		GS.earned_money = 1
		
	#print(GS.total_money)
