# res://weapons/BaseWeapon.gd
extends Node3D
class_name BaseWeapon

@export var data: WeaponData
@onready var muzzle: Node3D = $"Muzzle"  # must exist in the weapon scene

var _cooldown: float = 0.0

func _physics_process(delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown -= delta

func can_fire() -> bool:
	return _cooldown <= 0.0 and data != null and data.projectile_scene != null

func try_fire() -> void:
	if not can_fire():
		return
	_cooldown = 1.0 / max(0.001, data.fire_rate)
	_spawn_projectiles()

func _spawn_projectiles() -> void:
	var world: Node = get_tree().current_scene
	var forward_xy: Vector3 = muzzle.global_transform.basis.x # +X is forward in XY
	for i in data.burst_count:
		var proj := data.projectile_scene.instantiate() as BaseProjectile
		world.add_child(proj)
		var dir: Vector3 = _apply_xy_spread(forward_xy, data.spread_deg)
		proj.speed = data.muzzle_velocity
		proj.launch(muzzle.global_transform, dir)

func _apply_xy_spread(dir: Vector3, spread_deg: float) -> Vector3:
	if spread_deg <= 0.0:
		return dir.normalized()
	# Rotate around +Z so spread stays in the XY plane
	var ang: float = deg_to_rad(randf_range(-spread_deg * 0.5, spread_deg * 0.5))
	return dir.rotated(Vector3(0, 0, 1), ang).normalized()
