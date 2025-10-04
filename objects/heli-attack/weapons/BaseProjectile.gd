# res://projectiles/BaseProjectile.gd
extends Node3D
class_name BaseProjectile

@export var speed: float = 60.0
@export var life_time: float = 2.0

var _dir: Vector3 = Vector3(1, 0, 0)

func _ready() -> void:
	# Simple TTL; swap for a Timer node if you prefer
	get_tree().create_timer(life_time).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	travel(delta)
	
func launch(from: Transform3D, initial_dir: Vector3) -> void:
	global_transform = from
	_dir = initial_dir.normalized()
	
func travel(delta: float) -> void:
	global_position += _dir * speed * delta
