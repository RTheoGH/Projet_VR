extends Node3D
class_name Pressure_plate

var weight_on_plate : float = 0.0

@export var one_time_press : bool = false #Si jamais on veut que ce soit qu'une fois, mettre à true
@export var released_plate_color : Color = Color(1.0, 0.427, 0.243, 1.0)
@export var pressed_plate_color : Color = Color(0.0, 0.259, 0.094, 1.0)
signal plate_pressed
signal plate_released

func _ready() -> void:
	$"polySurface326_lambert1_0_001".material_override.albedo_color = released_plate_color

func get_weights() -> float:
	var total : float = 0.0
	for b in $Area3D.get_overlapping_bodies():
		if b.mass:
			total += b.mass
	return total

func _on_body_entered(body: Node3D) -> void:
	var previous_weight := weight_on_plate
	if is_instance_of(body, RigidBody3D):
		weight_on_plate += body.mass
		
	if previous_weight < 1.0 and weight_on_plate >= 1.0:
		$polySurface326_lambert1_0_001.position.y -= 3.0
		$"StaticBody3D".position.y -= 3.0
		$"polySurface326_lambert1_0_001".material_override.albedo_color = pressed_plate_color
		emit_signal("plate_pressed")


func _on_body_exited(body: Node3D) -> void:
	if one_time_press:
		return
	
	var previous_weight := weight_on_plate
	if is_instance_of(body, RigidBody3D):
		weight_on_plate -= body.mass
		
	if previous_weight >= 1.0 and weight_on_plate < 1.0:
		$"polySurface326_lambert1_0_001".position.y += 3.0
		$"StaticBody3D".position.y += 3.0
		$"polySurface326_lambert1_0_001".material_override.albedo_color = released_plate_color
		emit_signal("plate_released")
