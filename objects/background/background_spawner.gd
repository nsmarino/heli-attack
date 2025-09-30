extends Node3D

@export var bg_scene: PackedScene = preload("res://objects/background/background_tile.tscn")
@onready var timer = $Timer

@export var spawn_interval = 10.0

func _ready() -> void:
	# Configure timer
	timer.wait_time = spawn_interval
	timer.one_shot = false       # repeat
	timer.timeout.connect(_on_timer_timeout)
	Events.phase_changed.connect(_on_phase_change)
	
	# await get_tree().create_timer(0).timeout
	# _on_timer_timeout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var bg: Node3D = bg_scene.instantiate()
	get_parent().add_child(bg)

	bg.global_transform.origin = self.global_transform.origin

func _on_phase_change(phase):
	match phase:
		Events.Phase.WALK_CYCLE:
			_begin_walk_cycle()

func _begin_walk_cycle() -> void:
	_on_timer_timeout()
