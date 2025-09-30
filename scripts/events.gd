extends Node

enum Phase {
	WORKSHOP,
	WALK_CYCLE
}

signal floater_clicked
signal end_reached

signal phase_changed(phase: Phase)
