extends AIMove


@export var death_timer : float = 3


func check_transition(delta) -> Array:
	if duration_longer_than(death_timer):
		resources.gain_health(resources.max_health)
		return [true, "idle"]
	return [false, ""]
