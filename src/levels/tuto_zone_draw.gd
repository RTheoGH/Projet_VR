extends Node3D


func _on_pressure_plate_plate_pressed() -> void:
	$"../murs/MovableWall".position.z += 7.0


func _on_pressure_plate_plate_released() -> void:
	$"../murs/MovableWall".position.z -= 7.0
