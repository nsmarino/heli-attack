extends AIMove

func update(delta):
	print("idle state")

func check_transition(delta) -> Array:
	#if player.global_position.distance_to(spawn_point) < character.aggro_radius:
		#return [true, "pursuit"]
	return [false, ""]
