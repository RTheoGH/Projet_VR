@tool
extends XRToolsPickable

var RAY_LENGTH = 1000

var ink_decal = preload("res://src/scenes/draw_spell/ink_decal.tscn")
var is_drawing = false

var max_decals = 200 # Technically can have more but it is counted with some types of lights so idk i'll limit it
var active_decals : Array[Decal]
var collision_body : Node3D
var draw_rune : DrawRune = DrawRune.new()
var recognizer

var camera : Camera3D

func _ready():
	camera = get_viewport().get_camera_3d()
	recognizer = GestureRecognizer.new()
	recognizer.LoadGesturesFromResources("res://addons/Gesture_recognizer/resources/gestures/")

func _physics_process(delta: float) -> void:
	if is_drawing:
		draw_point(collision_body)

func draw_point(body: Node3D):
	var hit = cast_ray()
	var object_collide = $tip.get_collider()
	if hit && $tip.get_collider() is RigidBody3D:
		if(active_decals.size() >= max_decals):
			active_decals.pop_front().queue_free()
			
		var ink = ink_decal.instantiate()
		ink.position = hit[0]
		ink.rotation.x = atan2(hit[1].y , hit[1].z) + 90
		ink.rotation.y = atan2(hit[1].x , hit[1].z)
		ink.rotation.z = atan2(hit[1].x , hit[1].y)
		draw_rune.points.append(hit[0])
		draw_rune.normals.append(hit[1])
		
		active_decals.append(ink)
		object_collide.add_child(ink)
	
func activate(_pressed: bool):
	print('isDRAW? ', _pressed)
	is_drawing = _pressed
	if !is_drawing:
		if draw_rune.points.size() < 10:
			draw_rune.points.clear()
			draw_rune.normals.clear()
			return
			
		var score = recognizer.Recognize(draw_rune.get_2d_coordinates(recognizer, 0), 0.8)
		var rune_pos := draw_rune.get_mean_pos()
		if $tip.get_collider() is RigidBody3D:
			var effect_valid = RuneEffectManager.apply_effect_on_object(rune_pos, $tip.get_collider(), score["name"])
	else:
		active_decals.clear()
		draw_rune.points.clear()
		draw_rune.normals.clear()

func cast_ray():
	if $tip.get_collider() : 
		return [$tip.get_collision_point(), $tip.get_collision_normal()]
	return 
	
