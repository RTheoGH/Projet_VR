extends Node3D

# fake player
@onready var player := $CSGBox3D

func _ready():
	player.global_position = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
	Analytics.set_value("player", "age", 10)
	Analytics.set_value("player", "gender", "Ryan gosling")
	Analytics.add_monitored(player, "global_position", "system_balls", "positions")
	print(Analytics.get_all_user_data())

func _process(delta: float) -> void:
	player.global_position.y += 1.0 * delta
