# res://weapons/WeaponData.gd
extends Resource
class_name WeaponData

@export var display_name: StringName = &"Blaster"
@export var fire_rate: float = 6.0                      # shots per second
@export var projectile_scene: PackedScene
@export var muzzle_velocity: float = 60.0               # m/s (sets projectile.speed)
@export var burst_count: int = 1                        # 1 for single-shot
@export var spread_deg: float = 0.0                     # cone spread in degrees (XY plane)
@export var damage: float = 10.0
