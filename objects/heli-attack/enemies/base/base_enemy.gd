extends CharacterBody3D

@export var player : CharacterBody3D
@export var speed : float = 3

var spawn_point : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_point = global_position
