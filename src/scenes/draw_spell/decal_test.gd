extends Node3D

@onready var camera = $Camera3D


var ink_decal = preload("res://src/scenes/draw_spell/ink_decal.tscn")
var is_drawing = false

var max_decals = 500 # Technically can have more but it is counted with some types of lights so idk i'll limit it
var active_decals : Array[Decal]
var str_ref : String
var draw_rune : DrawRune

# Bounding box

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_rune = DrawRune.new()
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	if is_drawing:
		var mouse_pos = get_viewport().get_mouse_position() 
		var worldspace = camera.get_world_3d().direct_space_state
			
		var start = camera.project_ray_origin(mouse_pos)
		var end = camera.project_position(mouse_pos,100000)
		
		var query = PhysicsRayQueryParameters3D.create(start, end)
		var result = worldspace.intersect_ray(query)
		
		if result : 
			if(active_decals.size() >= max_decals):
				active_decals.pop_front().queue_free()
			
			var ink = ink_decal.instantiate()
			ink.position = result["position"]
			ink.rotation.x = 90
			#print("ink position : " , ink.position)
			str_ref += "Vector3" + str(ink.position) + ", "
			draw_rune.points.append(ink.position)
			draw_rune.normals.append(result["normal"])
			active_decals.append(ink)
			add_child(ink)
		else : 
			print("not hit")
		pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("draw_mouse_debug"):
		is_drawing = true
		#print("Draw")
		str_ref += "["
		draw_rune.points.clear()
		#for decal in range(active_decals.size()):
			#active_decals.pop_front().queue_free()
	if event.is_action_released("draw_mouse_debug"):
		is_drawing = false
		#print("Not drawing")
		#print(str_ref + "]")
		var recognizer = GestureRecognizer.new()
		#recognizer.AddGesture("res://addons/Gesture_recognizer/resources/gestures/", "explosion", draw_rune.get_2d_coordinates(recognizer, 0))
		#print("Gesture ajoutée !")
		recognizer.LoadGesturesFromResources("res://addons/Gesture_recognizer/resources/gestures/")
		var score = recognizer.Recognize(draw_rune.get_2d_coordinates(recognizer, 0), 0.85)
		$Camera3D/Label3D.text = "Rune reconnue : " + score["name"] + ", score : " + str(score["score"])
		print(score)

func detect_draw():
	pass

func draw_point():
	pass
