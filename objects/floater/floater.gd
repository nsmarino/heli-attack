extends Area3D

var clicked: bool = false
@onready var mesh = $Mesh
@onready var idleFx = $IdleFX
@onready var burstFx = $BurstFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)
	var tween = self.create_tween()
	self.global_position = Vector3(10,0,0)
	tween.tween_property(self, "global_position", Vector3(-10,0,0), 20)
	tween.tween_callback(destroy)

func _on_input_event(_camera: Node, event: InputEvent, _pos: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1 and clicked == false:
		clicked = true
		Events.floater_clicked.emit()
		disappear()

func disappear() -> void:
	mesh.queue_free()
	burstFx.emitting = true
	idleFx.queue_free()
	pass
	
func destroy() -> void:
	print("destroy")
	self.queue_free()
