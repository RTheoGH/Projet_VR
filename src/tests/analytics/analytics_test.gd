extends Node3D

# fake player
@onready var player := $CSGBox3D
var player_name := "Jean-Jacques"

func _ready():
	player.global_position = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
	Analytics.set_value("player", "age", 10)
	Analytics.set_value("player", "gender", "Ryan gosling")
	Analytics.push_value("system_balls", "positions", player.global_position)
	print(Analytics.get_all_user_data())

func _process(delta: float) -> void:
	player.global_position.y += 1.0 * delta
