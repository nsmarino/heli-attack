extends Node3D

@onready var deleteTimer: Timer = $DeleteTimer

var SPEED = 12
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Rotation", rotation)
	print("Global rotation", global_rotation)
	deleteTimer.timeout.connect(_on_timer_timeout)
	
func bulletTravel(delta):
	translate(Vector3(SPEED * delta, 0.0, 0.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	bulletTravel(delta)
	
func _on_timer_timeout() -> void:
	queue_free()
