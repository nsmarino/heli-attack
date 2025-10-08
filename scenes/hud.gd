extends CanvasLayer

@export var Player: CharacterBody3D

# Player Resources
@onready var healthBar: TextureProgressBar = $PlayerBars/Health
@onready var jumpBar: TextureProgressBar = $PlayerBars/Jump
@onready var specialBar: TextureProgressBar = $PlayerBars/Special

# Weapon
@onready var reloadBar: TextureProgressBar = $Reload

# Game progress
@onready var moneyLabel = $ProgressData/Money
@onready var enemyCount = $ProgressData/EnemyProgress/EnemyCount


func _ready() -> void:
	healthBar.max_value = Player.Resources.max_health
	healthBar.value = Player.Resources.health
	
	jumpBar.max_value = Player.Resources.max_jump
	jumpBar.value = Player.Resources.jump

	specialBar.max_value = Player.Resources.max_special
	specialBar.value = Player.Resources.special

	
	Player.Resources.update_player_health.connect(on_update_player_health)

func on_update_player_health(health) -> void:
	healthBar.value = health
