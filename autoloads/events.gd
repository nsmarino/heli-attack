extends Node

enum Phase {
	START,
	PLAY,
	END,
}

signal helicopter_destroyed
signal player_killed

signal phase_changed(phase: Phase)
