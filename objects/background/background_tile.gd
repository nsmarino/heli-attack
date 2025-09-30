extends Node3D

@export var bg_speed = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (self.global_position.x > -10):
		self.global_position.x -= (bg_speed *delta)
	else:
		print("q free")
		self.queue_free()
