extends Node3D

@onready var camera = $Camera3D


var ink_decal = preload("res://src/scenes/draw_spell/ink_decal.tscn")
var is_drawing = false

var max_decals = 50 # Technically can have more but it is counted with some types of lights so idk i'll limit it
var active_decals : Array[Decal]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
			print("ink position : " , ink.position)
			active_decals.append(ink)
			add_child(ink)
		else : 
			print("not hit")
		pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("draw_mouse_debug"):
		is_drawing = true
		print("Draw")
	if event.is_action_released("draw_mouse_debug"):
		is_drawing = false
		print("Not drawing")

func detect_draw():
	pass

func draw_point():
	pass
