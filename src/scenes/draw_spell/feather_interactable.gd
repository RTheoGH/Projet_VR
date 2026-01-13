@tool
extends XRToolsPickable

const min_move_dist = 0.01

var ink_decal = preload("res://src/scenes/draw_spell/ink_decal.tscn")
var is_drawing = false

var max_decals = 200 # Technically can have more but it is counted with some types of lights so idk i'll limit it
var active_decals : Array[Decal]
var collision_body : Node3D
var draw_rune : DrawRune = DrawRune.new()
static var recognizer

var camera : Camera3D
var currently_grabbed_old_damping: float
var currently_grabbed: RigidBody3D
@onready var target: Marker3D = $target

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func _ready():
	super()
	camera = get_viewport().get_camera_3d()
	if not recognizer:
		recognizer = GestureRecognizer.new()
		recognizer.LoadGesturesFromResources("res://addons/Gesture_recognizer/resources/gestures/")

var last_position: Vector3
func _physics_process(_delta: float) -> void:
	
	if is_instance_valid(currently_grabbed):
		var dir := (target.global_position - currently_grabbed.global_position)
		currently_grabbed.apply_central_force(dir * 25.0)
	
	if is_drawing && last_position.distance_squared_to(global_position) >= min_move_dist**2:
		draw_point(collision_body)
		last_position = global_position

func draw_point(_body: Node3D):
	var hit = cast_ray()
	var object_collide = $tip.get_collider()
	if hit && object_collide:
		if(active_decals.size() >= max_decals):
			active_decals.pop_front().queue_free()
			
		var ink: Decal = ink_decal.instantiate()
		object_collide.add_child(ink)
		ink.global_position = hit[0]
		ink.global_transform = align_with_y(ink.global_transform, hit[1])
		if object_collide is RigidBody3D:
			draw_rune.points.append(hit[0])
			draw_rune.normals.append(hit[1])
		else:
			ink.modulate = Color("5d1a12")
		
		active_decals.append(ink)
	
func activate(_pressed: bool):
	
	#print('isDRAW? ', _pressed)
	is_drawing = _pressed
	
	if is_instance_valid(currently_grabbed):
		RuneEffectManager.next_highlight(currently_grabbed, "pickable")
		currently_grabbed.gravity_scale = 1.0
		currently_grabbed.linear_damp = currently_grabbed_old_damping
		currently_grabbed = null
	
	if !is_drawing:
		if draw_rune.points.size() < 10:
			draw_rune.points.clear()
			draw_rune.normals.clear()
			return
		
		#recognizer.AddGesture("res://addons/Gesture_recognizer/resources/gestures/", "gravity", draw_rune.get_2d_coordinates(recognizer, 0)) 
		var score = recognizer.Recognize(draw_rune.get_2d_coordinates(recognizer, 0), 0.8)
		var rune_pos := draw_rune.get_mean_pos()
		if $tip.get_collider() is RigidBody3D:
			var effect_valid = RuneEffectManager.apply_effect_on_object(rune_pos, $tip.get_collider(), score["name"])
			if effect_valid:
				for d in active_decals:
					d.queue_free()
				active_decals.clear()
				draw_rune.points.clear()
				draw_rune.normals.clear()
	else:
		for d in active_decals:
			d.queue_free()
		active_decals.clear()
		draw_rune.points.clear()
		draw_rune.normals.clear()

func cast_ray():
	if $tip.get_collider() : 
		return [$tip.get_collision_point(), $tip.get_collision_normal()]
	return 
	

func start_grab(object: RigidBody3D):
	currently_grabbed = object
	currently_grabbed.linear_damp = 2
	

func _on_grabbed(_pickable: Variant, _by: Variant) -> void:
	RuneEffectManager.current_feather = self


func _on_dropped(_pickable: Variant) -> void:
	
	if is_instance_valid(currently_grabbed):
		RuneEffectManager.next_highlight(currently_grabbed, "pickable")
		currently_grabbed.gravity_scale = 1.0
		currently_grabbed.linear_damp = currently_grabbed_old_damping
		currently_grabbed = null
