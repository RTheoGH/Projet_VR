extends Node3D

@onready var camera = $Camera3D


var ink_decal = preload("res://src/scenes/draw_spell/ink_decal.tscn")
var is_drawing = false

var max_decals = 500 # Technically can have more but it is counted with some types of lights so idk i'll limit it
var active_decals : Array[Decal]
var str_ref : String
var draw_rune : DrawRune
var last_object
var recognizer

# Bounding box
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_rune = DrawRune.new()
	recognizer = GestureRecognizer.new()
	recognizer.LoadGesturesFromResources("res://addons/Gesture_recognizer/resources/gestures/")
	print($Camera3D)
	Gamemaster.player = Node3D.new()
	Gamemaster.player.global_position = $Camera3D.global_position
	#await get_tree().create_timer(3).timeout
	#RuneEffectManager.
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	if is_drawing:
		var mouse_pos = get_viewport().get_mouse_position() 
		var worldspace = camera.get_world_3d().direct_space_state
			
		var start = camera.project_ray_origin(mouse_pos)
		var end = camera.project_position(mouse_pos,100000)
		
		var query = PhysicsRayQueryParameters3D.create(start, end)
		var result = worldspace.intersect_ray(query)
		
		if result and result["collider"] != $FeatherInteractable : 
			if(active_decals.size() >= max_decals):
				active_decals.pop_front().queue_free()
			
			#var result_pos = result["position"]
			#$FeatherInteractable.global_position = result_pos
			#$FeatherInteractable.position.z -= 0.05
			#
			#$FeatherInteractable.activate(true)
	#else:
		#$FeatherInteractable.activate(false)
			#
			
			var ink = ink_decal.instantiate()
			result["collider"].add_child(ink)
			ink.global_position = result["position"]
			ink.global_transform = align_with_y(ink.global_transform, result["normal"])
			draw_rune.points.append(ink.global_position)
			draw_rune.normals.append(result["normal"])
			active_decals.append(ink)
			
		else : 
			print("not hit")
		pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("draw_mouse_debug"):
		is_drawing = true
		#print("Draw")
		str_ref += "["
		draw_rune.points.clear()
		for decal in range(active_decals.size()):
			active_decals.pop_front().queue_free()
	if event.is_action_released("draw_mouse_debug"):
		print("allo")
		is_drawing = false
		#print("Not drawing")
		#print(str_ref + "]")
		
		#recognizer.AddGesture("res://addons/Gesture_recognizer/resources/gestures/", "duplication", draw_rune.get_2d_coordinates(recognizer, 0))
		#print("Gesture ajoutée !")
		if draw_rune.points.size() < 10:
			draw_rune.points.clear()
			draw_rune.normals.clear()
			return

		Gamemaster.player = $XROrigin3D
		var score = recognizer.Recognize(draw_rune.get_2d_coordinates(recognizer, 0), 0.8)
		recognizer.AddGesture("res://addons/Gesture_recognizer/resources/gestures/", "pickable", draw_rune.get_2d_coordinates(recognizer, 0))
		$Camera3D/Label3D.text = "Rune reconnue : " + score["name"] + ", score : " + str(score["score"])
		print(score)
		RuneEffectManager.apply_effect_on_object(Vector3.ZERO, $RigidBody3D, score["name"])

func detect_draw():
	pass

func draw_point():
	pass
