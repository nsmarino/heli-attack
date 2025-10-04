# HelicopterPatrolWithCurve_Strict.gd
extends CharacterBody3D

# --- Horizontal patrol ---
@export var base_speed: float = 6.0
@export var patrol_distance: float = 16.0
@export var patrol_axis: Vector3 = Vector3(1, 0, 0) # world-space axis

# Speed falls near the edges using this curve:
# x in [0..1] = normalized distance from center (0=center, 1=edge)
# y in [0..1] = speed factor
@export var speed_curve: Curve
@export var min_speed_factor: float = 0.12

# --- Vertical bob ---
@export var bob_amplitude: float = 0.6
@export var bob_frequency: float = 0.5   # cycles per second
@export var bob_phase: float = 0.0       # radians

# --- Facing (optional) ---
@export var face_velocity: bool = true

const TWO_PI: float = PI * 2.0

var _axis_norm: Vector3 = Vector3.RIGHT
var _center_pos: Vector3
var _base_y: float = 0.0
var _dir_sign: float = 1.0
var _t: float = 0.0

func _ready() -> void:
	_axis_norm = patrol_axis.normalized()
	if _axis_norm == Vector3.ZERO:
		_axis_norm = Vector3.RIGHT

	_center_pos = global_position
	_base_y = _center_pos.y

	# Provide a default curve if none is set
	if speed_curve == null:
		speed_curve = Curve.new()
		# Fast across most of the span, taper near the edge
		speed_curve.add_point(Vector2(0.0, 1.0))
		speed_curve.add_point(Vector2(0.7, 1.0))
		speed_curve.add_point(Vector2(1.0, 0.0))

func _physics_process(delta: float) -> void:
	_t += delta

	# Distance limits
	var half: float = max(0.001, patrol_distance * 0.5)

	# Where are we along the patrol axis?
	var pos: Vector3 = global_position
	var offset_along_axis: float = (pos - _center_pos).dot(_axis_norm)

	# --- Curve-based horizontal speed (slow near edges) ---
	var progress: float = clamp(abs(offset_along_axis) / half, 0.0, 1.0)
	var factor: float = speed_curve.sample_baked(progress)
	factor = max(min_speed_factor, factor)
	var horiz_speed: float = base_speed * factor

	# Apply horizontal velocity along the axis (XZ plane)
	velocity.x = _axis_norm.x * (_dir_sign * horiz_speed)
	velocity.z = _axis_norm.z * (_dir_sign * horiz_speed)

	# Flip direction at the ends (snap to the edge to avoid drift)
	if offset_along_axis > half and _dir_sign > 0.0:
		_dir_sign = -1.0
		var edge: Vector3 = _center_pos + _axis_norm * half
		global_position = Vector3(edge.x, global_position.y, edge.z)
	elif offset_along_axis < -half and _dir_sign < 0.0:
		_dir_sign = 1.0
		var edge2: Vector3 = _center_pos - _axis_norm * half
		global_position = Vector3(edge2.x, global_position.y, edge2.z)

	# --- Vertical bob: follow a sine target on Y exactly ---
	var omega: float = TWO_PI * bob_frequency
	var target_y: float = _base_y + bob_amplitude * sin(_t * omega + bob_phase)
	velocity.y = (target_y - global_position.y) / max(delta, 1e-6)

	move_and_slide()

	# --- Optional: yaw to face horizontal velocity ---
	if face_velocity:
		var v2: Vector2 = Vector2(velocity.x, velocity.z)
		if v2.length() > 0.01:
			# Default -Z is "forward" in Godot; adjust if your mesh faces another axis.
			var yaw: float = atan2(v2.x, v2.y)
			rotation.y = yaw
			# rotation.y = lerp_angle(rotation.y, yaw, 0.15)
