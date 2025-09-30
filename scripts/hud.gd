extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var timer: Timer = $UpdateTimer

@export var max_health: int = 1000
var current_health: int = max_health
var floater_increase: int = 100

func _ready() -> void:
	# Configure timer
	timer.wait_time = 1.0        # 5 seconds
	timer.one_shot = false       # repeat
	timer.timeout.connect(_on_timer_timeout)
	Events.phase_changed.connect(_on_phase_change)
	# timer.start()

	# Initialize bar
	health_bar.min_value = 0
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	Events.floater_clicked.connect(on_floater_clicked)

func _on_timer_timeout() -> void:
	# Example: simulate taking random damage every tick
	# var damage = randi_range(5, 20)
	var damage = 10
	current_health = max(current_health - damage, 0)
	health_bar.value = current_health
	
func on_floater_clicked() -> void:
	current_health = min(current_health + floater_increase, max_health)
	print("Health updated:", current_health)
	health_bar.value = current_health

func _on_phase_change(phase) -> void:
		match phase:
			Events.Phase.WALK_CYCLE:
				_on_walk_cycle()

func _on_walk_cycle() -> void:
	timer.start()
