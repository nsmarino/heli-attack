extends Node3D

@export var floater_scene: PackedScene = preload("res://objects/floater/floater.tscn")
@onready var timer = $Timer

@export var spawn_interval = 10.0

func _ready() -> void:
	# Configure timer
	timer.wait_time = spawn_interval
	timer.one_shot = false       # repeat
	timer.timeout.connect(_on_timer_timeout)
	Events.phase_changed.connect(_on_phase_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var floater: Node3D = floater_scene.instantiate()
	get_parent().add_child(floater)
	floater.global_transform.origin = global_transform.origin
	
func _on_phase_change(phase) -> void:
		match phase:
			Events.Phase.WALK_CYCLE:
				_on_walk_cycle()

func _on_walk_cycle() -> void:
	print("begin walk cycle")
	timer.start()
