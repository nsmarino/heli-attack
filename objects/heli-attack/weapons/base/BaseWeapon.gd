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
	var forward_xy: Vector3 = -muzzle.global_transform.basis.z # -Z is forward
	for i in data.burst_count:
		var proj := data.projectile_scene.instantiate() as BaseProjectile
		world.add_child(proj)
		proj.speed = data.muzzle_velocity
		proj.damage = data.damage
		proj.launch(muzzle.global_transform, forward_xy)
