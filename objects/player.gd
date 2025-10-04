extends CharacterBody3D

@export var camera_path: NodePath  # assign your Camera3D in the Inspector
@export var smooth: bool = true
@export var turn_speed: float = 12.0  # only used if smooth = true
@onready var cam: Camera3D = get_node(camera_path)

# var projectile = preload("res://objects/heli-attack/projectile.tscn")
@export var weapon_scenes: Array[PackedScene] = []   # assign Blaster.tscn, etc. in Inspector

@onready var WeaponPivot: Node3D = $WeaponPivot
@onready var WeaponSocket: Node3D = $WeaponPivot/WeaponSocket

# World XY plane at z=0
const TARGET_PLANE := Plane(Vector3(0, 0, 1), 0.0)

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var _weapons: Array[BaseWeapon] = []
var _current_weapon: BaseWeapon
var _current_index: int = 0

func _ready() -> void:
	_instance_weapons()
	_equip(0)

func _instance_weapons() -> void:
	_weapons.clear()
	for s in weapon_scenes:
		var w := s.instantiate() as BaseWeapon
		WeaponSocket.add_child(w)
		w.visible = false
		_weapons.append(w)

func _equip(index: int) -> void:
	if _weapons.is_empty():
		_current_weapon = null
		return
	_current_index = (index % _weapons.size() + _weapons.size()) % _weapons.size()
	for i in _weapons.size():
		_weapons[i].visible = (i == _current_index)
	_current_weapon = _weapons[_current_index]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	if cam == null:
		return
	if (Input.is_action_pressed("Shoot") and _current_weapon != null):
		_current_weapon.try_fire()

	# 1) Get mouse position in viewport
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()

	# 2) Build ray from camera through that pixel
	var ray_origin: Vector3 = cam.project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = cam.project_ray_normal(mouse_pos)

	# 3) Intersect with the XY plane (z = 0)
	var hit: Variant = TARGET_PLANE.intersects_ray(ray_origin, ray_dir)
	if hit == null:
		return  # ray is parallel to plane (shouldn't happen with this setup)

	var hit_point: Vector3 = hit

	# 4) Compute desired angle around Z so the gun points toward hit_point in XY
	var gun_pos: Vector3 = WeaponPivot.global_transform.origin
	var to_target_xy: Vector2 = Vector2(hit_point.x - gun_pos.x, hit_point.y - gun_pos.y)
	var desired_angle: float = atan2(to_target_xy.y, to_target_xy.x)  # radians

	# 5) Apply rotation only around Z
	if smooth:
		WeaponPivot.rotation.z = lerp_angle(WeaponPivot.rotation.z, desired_angle, 1.0 - pow(0.001, delta * turn_speed))
	else:
		WeaponPivot.rotation.z = desired_angle

#func handleShoot() -> void:
	#if shootCooldown.is_stopped():
		#shootCooldown.start()
		#print("shoot on cooldown")
		#var projectile_instance = projectile.instantiate()
		#get_tree().get_root().add_child(projectile_instance)
		#projectile_instance.transform = Muzzle.global_transform

func _unhandled_input(event: InputEvent) -> void:
	pass
	#if event is InputEventMouseButton and event.pressed:
		#var mb := event as InputEventMouseButton
		#if mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			#_equip(_current_index + 1)
		#elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#_equip(_current_index - 1)
