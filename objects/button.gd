extends Button


func _ready():
	self.pressed.connect(_button_pressed)

func _button_pressed():
	Events.phase_changed.emit(Events.Phase.WALK_CYCLE)
