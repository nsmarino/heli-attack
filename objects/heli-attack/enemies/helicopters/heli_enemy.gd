extends BaseEnemy

@export var weapon_scene: PackedScene  # assign Blaster.tscn, etc. in Inspector
@onready var WeaponSocket: Node3D = $WeaponSocket


func _ready() -> void:
	_instance_weapon()

func _instance_weapon() -> void:
	var weapon := weapon_scene.instantiate() as BaseWeapon
	WeaponSocket.add_child(weapon)
	
func _process(delta: float) -> void:
	var target = Vector3(player.global_position.x, player.global_position.y+1, player.global_position.z)
	WeaponSocket.look_at(target)
