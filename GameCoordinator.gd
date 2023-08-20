extends Node2D

onready var tutorial = $CanvasLayer/GameUI/Tutorial
onready var win_lose = $WinLose

# Used to help make sure we spawn at least one Scary guy.
enum ScaryState {
	NOT_YET,
	WANT_TO_SPAWN,
	DONE
}

var flag_mandatory_scary = ScaryState.NOT_YET
var wants_to_win = false

# In later stages of the game, this is used to make sure the game is moving
# forward at a reasonable pace.
var spawn_counter = 0
# This tracks the value of GS.total_money that we did have, that we will
# increment if it hasn't reached a checkpoint.
var next_spawn_base_value = 0

func spawn_increment(value_amount):
	# This is done to prevent harder games from moving too much more quickly
	# than normal games
	value_amount /= GS.difficulty_multiplier
	
	# The first time this is called, nothing has happened; just prepare for
	# the next invocation.
	if spawn_counter == 0:
		next_spawn_base_value = GS.total_money
		return
		
	var needed = (next_spawn_base_value + value_amount)
	if GS.total_money < needed:
		GS.total_money = needed
	
	next_spawn_base_value = GS.total_money
	spawn_counter += 1

func y_minimum():
	if GS.get_total_money() <= 3000:
		return 200
	if GS.get_total_money() <= 6000:
		return 500
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
	# Can't spawn if we're trying to win.
	if wants_to_win:
		return
	
	# Compute maximum number of living VirusCollections
	var max_collects = 2
	if GS.get_total_money() > 12000:
		max_collects = 1
	
	# We can only have at most 2 (or fewer...?) virus collections at once.
	if not vc_count_is_this_or_fewer(max_collects - 1):
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
		
	if GS.get_total_money() <= 2700:
		spawn_weak_vc()
	elif GS.get_total_money() <= 6000:
		spawn_somewhat_weak_vc()
	elif GS.get_total_money() <= 12000:
		spawn_level_3_vc()
	elif GS.get_total_money() <= 18000:
		# There should be only ~three of these thanks to spawn_increment
		spawn_level_4_vc()
	elif GS.get_total_money() <= 24000:
		spawn_level_5_vc()
	elif GS.get_total_money() < 30000:
		spawn_level_6_vc()
	elif GS.get_total_money() < 36000:
		spawn_level_7_vc()
	elif GS.get_total_money() < 42000:
		spawn_level_8_vc()
	elif GS.get_total_money() < 48000:
		spawn_level_9_vc()
	else:
		spawn_freeplay_vc()
		#spawn_vc(0.3, 10)
	
# Spawns a virus collection that is "weak", i.e. the kind that you encounter
# right at the beginning of the game.
func spawn_weak_vc():
	# "Scare" virus collection -- fast moving and fast spawning,
	# but has a very low cap.
	var may_spawn_scary_rng = flag_mandatory_scary == ScaryState.DONE
	may_spawn_scary_rng = may_spawn_scary_rng and (GS.get_total_money() >= 550 and GS.get_total_money() <= 2300)
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
	
	var t = (GS.get_total_money() - money_min) / (money_max - money_min)
	t = clamp(t, 0, 1)
	t = sqrt(t)
	
	#print(t)
	
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
	
	if GS.get_total_money() >= 3400 and GS.get_total_money() <= 5500:
		# Scary
		if randf() < 0.5:
			#print("Scare!")
			var vc: Node2D = spawn_vc(rand_range(0.2, 0.4), 0, 7, 1.1, 13)
			vc.add_to_group("Scary")
			return
	
	var t = (GS.get_total_money() - money_min) / (money_max - money_min)
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
	
	var t = (GS.get_total_money() - money_min) / (money_max - money_min)
	t = clamp(t, 0, 1)
	t = sqrt(t)
	
	var spawn_timer = lerp(1.5, 0.8, t)
	var generation = 0
	var prime = round(rand_range(40, 60))
	
	spawn_vc(spawn_timer, prime, generation)
	
func spawn_level_4_vc():
	spawn_increment(2000)
	
	var money_min = 12000.0
	var money_max = 20000.0
	
	var t = (GS.get_total_money() - money_min) / (money_max - money_min)
	t = clamp(t, 0, 1)
	t = sqrt(t)
	
	var spawn_timer = lerp(0.7, 0.4, t)
	var generation = 0
	var prime = round(rand_range(40, 60))
	
	spawn_vc(spawn_timer, prime, generation, 1.2, 19, 150)
	
		
func spawn_level_5_vc():
	spawn_increment(2500)
	
	var money_min = 18000.0
	var money_max = 24000.0
	
	var t = (GS.get_total_money() - money_min) / (money_max - money_min)
	t = clamp(t, 0, 1)
	t = sqrt(t)
	
	var spawn_timer = lerp(0.4, 0.2, t)
	var generation = 0
	var prime = round(rand_range(40, 60))
	
	spawn_vc(spawn_timer, prime, generation, 1.4, 20, 500)
	
func spawn_level_6_vc():
	spawn_increment(2500)
	
	var money_min = 24000.0
	var money_max = 30000.0
	
	var t = (GS.get_total_money() - money_min) / (money_max - money_min)
	t = clamp(t, 0, 1)
	t = sqrt(t)
	
	var spawn_timer = lerp(0.2, 0.1, t)
	var generation = 0
	var prime = round(rand_range(40, 60))
	
	spawn_vc(spawn_timer, prime, generation, 1.8, 20, 500)
	
func spawn_level_7_vc():
	spawn_increment(3000)
	
	var money_min = 30000.0
	var money_max = 36000.0
	
	#var t = (GS.get_total_money() - money_min) / (money_max - money_min)
	#t = clamp(t, 0, 1)
	#t = sqrt(t)
	
	var spawn_timer = 0.1 #lerp(0.2, 0.1, t)
	var generation = 0
	var prime = round(rand_range(120, 180))
	
	spawn_vc(spawn_timer, prime, generation, 2.0, 20, 500)
	
func spawn_level_8_vc():
	spawn_increment(3000)
	
	#var money_min = 30000.0
	#var money_max = 36000.0
	
	#var t = (GS.get_total_money() - money_min) / (money_max - money_min)
	#t = clamp(t, 0, 1)
	#t = sqrt(t)
	
	var spawn_timer = 0.1 #lerp(0.2, 0.1, t)
	var generation = 0
	var prime = round(rand_range(120, 180))
	
	spawn_vc(spawn_timer, prime, generation, 2.5, 20, 500)
	
	
func spawn_level_9_vc():
	spawn_increment(2500)
	
	#var money_min = 30000.0
	#var money_max = 36000.0
	
	#var t = (GS.get_total_money() - money_min) / (money_max - money_min)
	#t = clamp(t, 0, 1)
	#t = sqrt(t)
	
	var spawn_timer = 0.1 #lerp(0.2, 0.1, t)
	var generation = 0
	var prime = round(rand_range(120, 180))
	
	spawn_vc(spawn_timer, prime, generation, 4.0, 20, 500)
	
func spawn_freeplay_vc():
	spawn_increment(3000)
	
	#var money_min = 30000.0
	#var money_max = 36000.0
	
	#var t = (GS.get_total_money() - money_min) / (money_max - money_min)
	#t = clamp(t, 0, 1)
	#t = sqrt(t)
	
	var t = GS.total_money - 54000
	var speed = 4 + (t / 2000.0) * 0.4
	#print(speed)
	
	var spawn_timer = 0.1 - (t / 4000.0) #lerp(0.2, 0.1, t)
	spawn_timer = clamp(spawn_timer, 0.01666 * 2, 1.0)
	var generation = 0
	var prime = round(rand_range(120, 180))
	
	spawn_vc(spawn_timer, prime, generation, speed, 24, 500)
	
	
# Formula for bounds:
# (1440 - (64 * generation)) / 2 gives approx bounds
func spawn_vc(spawn_timer, prime = 0, generation = 0, speed_mul = 1, max_strength = 18, back_y = 32):
	var vc = GS.VirusCollection.instance()
	vc.spawn_timer_max = spawn_timer
	vc.position.y = -1280 - back_y
	
	vc.speed_mul = speed_mul
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
		
func vc_count_is_this_or_fewer(count):
	var c = get_tree().get_nodes_in_group("VirusCollection").size()
	if GS.armored_virus_count > 0:
		c += 1
		
	return c <= count

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randf() < 0.5:
		# We try to spawn randomly.
		try_to_spawn()
	
	if Input.is_action_just_pressed("test_spawn"):
		pass
		
	# This is *total_money*, so it includes the initial 100 we start out with.
	if GS.get_total_money() >= 150:
		try_open_tutorial(1)
		
	if GS.get_total_money() >= 1500:
		try_open_tutorial(3)
		
	if GS.get_total_money() >= 550:
		try_open_tutorial(2)
		flag_mandatory_scary = ScaryState.WANT_TO_SPAWN
		
	# Give player some big money even in somewhat_weka
	if GS.get_total_money() >= 3300:
		GS.earned_money = 5
	if GS.get_total_money() >= 7000:
		GS.earned_money = 1
	if GS.get_total_money() >= 54000: # need to decide this of course ? 
		wants_to_win = true
		
		# Wait for all viruses to be gone to win
		if vc_count_is_this_or_fewer(0):
			win_lose.win()
			wants_to_win = false
	# Antisoftlock: we always need to be able to have at least 1 ship.
	if not GS.has_any_ship() and GS.money < 50:
		GS.money = 50
		
	#print(GS.get_total_money())
