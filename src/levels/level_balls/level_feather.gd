extends Node3D

var duplication_plates_count := 0
var duplication_door_opened := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RuneEffectManager.explosion_signal.connect(on_explosion_signal)
	#RuneEffectManager.apply_pickable($DynamicProps/Crate2, $DynamicProps/Crate2.global_position)
	#RuneEffectManager.apply_effect_on_object($DynamicProps/Crate2.global_position, $DynamicProps/Crate2, "pickable")
	RuneEffectManager.apply_effect_on_object($DynamicProps/Crate2.global_position, $DynamicProps/Crate2, "gravity")
	#RuneEffectManager.apply_effect_on_object($DynamicProps/Crate2.global_position, $DynamicProps/Crate2, "explosion")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressure_plate_plate_pressed() -> void:
	create_tween().tween_property($StaticProps/Wall1, "global_position", Vector3(-7.658, 1.126, 11.791), 1.0)


func _on_pressure_plate_plate_released() -> void:
	create_tween().tween_property($StaticProps/Wall1, "global_position", Vector3(-8.546, 1.126, 6.601), 1.0)

func on_explosion_signal(pos : Vector3, explosion_range : float):
	var wall_pos = $StaticProps/Wall2.global_position
	if (wall_pos - pos).length() <= explosion_range:
		var wall_explodes = load("res://spells/scenes/explosion.tscn").instantiate()
		add_child(wall_explodes)
		wall_explodes.global_position = wall_pos
		$StaticProps/Wall2.queue_free()
		

func _on_pressure_plate_duplication_pressed() -> void:
	if duplication_door_opened:
		return
		
	duplication_plates_count += 1
	if duplication_plates_count >= 3:
		duplication_door_opened = true
		$DynamicProps/DuplicationPlates/Pressure_plate.one_time_press = true
		$DynamicProps/DuplicationPlates/Pressure_plate2.one_time_press = true
		$DynamicProps/DuplicationPlates/Pressure_plate3.one_time_press = true
		create_tween().tween_property($StaticProps/Wall3, "global_position", Vector3(-25.292, 2.765, -0.21), 1.0)
		
func _on_pressure_plate_duplication_released() -> void:
	duplication_plates_count -= 1

func _on_pressure_plate_gravity_pressed() -> void:
	create_tween().tween_property($DynamicProps/ButtonWall, "global_position", Vector3(-11.144, 6.05, -0.854), 1.0)
	create_tween().tween_property($StaticProps/Bench4, "global_position", Vector3(-13.762, 3.668, 6.819), 3)
