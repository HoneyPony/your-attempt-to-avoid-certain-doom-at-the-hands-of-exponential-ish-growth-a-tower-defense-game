extends Node2D

func check_y_prob():
	var vc = get_tree().get_nodes_in_group("VirusCollection")
	var y = 1280
	for v in vc:
		if v.position.y < y:
			y = v.position.y
			
	var probability = (y - (-400.0)) / (1280.0 * 2)
	#print(probability)
	# We are more likely to spawn if the other virus collections are far
	# down on screen. We can't even spawn at all if they're near the top.
	return randf() < probability

func try_to_spawn():
	# We can only have at most 2 virus collections at once.
	if get_tree().get_nodes_in_group("VirusCollection").size() >= 2:
		return
		
	# Don't spawn much if there's already virus collections near the top of
	# the screen.
	if not check_y_prob():
		return
		
	spawn_weak_vc()
	
# Spawns a virus collection that is "weak", i.e. the kind that you encounter
# right at the beginning of the game.
func spawn_weak_vc():
	# Maybe the maximum money that we would expect to be weak?
	var money_max = 3000.0
	# Where the weak things are completely weak.
	var money_min = 120.0
	
	var t = (GS.total_money - money_min) / (money_max - money_min)
	t = clamp(t, 0, 1)
	t = sqrt(t)
	
	#print(t)
	
	var spawn_timer = lerp(4.0, 2.5, t)
	var generation = ceil(lerp(9, 5, t))
	var prime = lerp(0, 7, t)
	prime = round(prime + rand_range(0, 2.5))
	
	spawn_vc(spawn_timer, prime, generation)
	#print("Spanwed weak vC!")
	
# Formula for bounds:
# (1440 - (64 * generation)) / 2 gives approx bounds
func spawn_vc(spawn_timer, prime = 0, generation = 0, max_strength = 18):
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
	add_child(vc)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rand_range(0, 1) < 0.1:
		# We try to spawn randomly.
		try_to_spawn()
	
	if Input.is_action_just_pressed("test_spawn"):
		pass
		
	if GS.total_money >= 3000:
		GS.earned_money = 1
