extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressure_plate_plate_pressed() -> void:
	create_tween().tween_property($StaticProps/Wall1, "global_position", Vector3(-7.658, 1.126, 11.791), 1.0)


func _on_pressure_plate_plate_released() -> void:
	create_tween().tween_property($StaticProps/Wall1, "global_position", Vector3(-8.546, 1.126, 6.601), 1.0)
