extends Node3D

@onready var animationPlayer = $MeshInstance3D/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.phase_changed.connect(_on_phase_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_phase_changed(phase) -> void:
	match phase:
		Events.Phase.WALK_CYCLE:
			_begin_walk_cycle()

func _begin_walk_cycle() -> void:
	animationPlayer.play("uv_offset_x")
