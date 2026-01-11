extends Node

var activated_rune_effects : Dictionary = {}
signal explosion_signal(from : Vector3, range : float)
const highlight_explosion = preload("res://src/shaders/explosion_highlight_material.tres")
const highlight_pickable = preload("res://src/shaders/pickable_highlight_material.tres")
const highlight_gravity = preload("res://src/shaders/pickable_highlight_material.tres")
const highlight_duplication = preload("res://src/shaders/pickable_highlight_material.tres")

func _ready() -> void:
	highlight_pickable.set_shader_parameter("Emission_color", Color(0.955, 0.585, 0.0, 1.0))
	highlight_gravity.set_shader_parameter("Emission_color", Color(0.619, 0.382, 0.994, 1.0))
	highlight_duplication.set_shader_parameter("Emission_color", Color(0.182, 0.723, 0.348, 1.0))

func apply_effect_on_object(draw_pos : Vector3, object : RigidBody3D, effect : String) -> bool:
	if object == null or effect == "No match":
		return false
	if activated_rune_effects.keys().has(object):
		activated_rune_effects[object].append(effect)
	else :
		activated_rune_effects[object] = [effect]
		print(activated_rune_effects)
		
	match effect:
		"pickable":
			apply_pickable(object, draw_pos)
			return true
		"explosion":
			apply_explosion(object, draw_pos)
			return true
		"gravity":
			apply_gravity(object)
			return true
		"duplication":
			apply_duplication(object, draw_pos)
			return true
	return false

func apply_pickable(object : RigidBody3D, draw_pos : Vector3 = Vector3.ZERO):
	if not object: return
	var xr_pickable := XRToolsPickable.new()
	print(object)
	var object_pos := object.global_position
	object.add_child(xr_pickable)
	xr_pickable.global_position = object_pos
	
	var normal := (draw_pos - object_pos).normalized()
	
	var left_hand = XRToolsGrabPointHand.new()
	xr_pickable.add_child(left_hand)
	left_hand.global_position = draw_pos
	left_hand.hand = XRToolsGrabPointHand.Hand.LEFT
	
	left_hand.rotation.x = atan2(normal.y , normal.z) + 90
	left_hand.rotation.y = atan2(normal.x , normal.z)
	left_hand.rotation.z = atan2(normal.x , normal.y)
	
	var right_hand = XRToolsGrabPointHand.new()
	xr_pickable.add_child(right_hand)
	right_hand.global_position = draw_pos
	right_hand.hand = XRToolsGrabPointHand.Hand.RIGHT
	
	right_hand.rotation.x = atan2(normal.y , normal.z) + 90
	right_hand.rotation.y = atan2(normal.x , normal.z)
	right_hand.rotation.z = atan2(normal.x , normal.y)
	
	apply_highlight(object, true, highlight_pickable)
	
	#get_tree().create_timer(15).timeout.connect(pickable_finished.bind(object, xr_pickable))
	
func pickable_finished(object : RigidBody3D, xr_pickable : RigidBody3D):
	if not object: return
	activated_rune_effects[object].erase("pickable")
	next_highlight(object, "pickable")
	print(activated_rune_effects)
	xr_pickable.queue_free()

func apply_explosion(object : RigidBody3D, draw_pos : Vector3):
	if not object: return
	apply_highlight(object, true, highlight_explosion)
	get_tree().create_timer(5).timeout.connect(explosion_finished.bind(object, draw_pos))

func explosion_finished(object : RigidBody3D, draw_pos : Vector3):
	if not object: return
	object.apply_central_impulse((draw_pos - object.global_position).normalized() * 5.0)
	explosion_signal.emit(draw_pos, 2.0)
	var explosion_scene = load("res://spells/scenes/explosion.tscn").instantiate()
	next_highlight(object, "explosion")
	print(activated_rune_effects)
	object.add_child(explosion_scene)
	explosion_scene.scale = object.scale
	# object.queue_free() ?

func apply_gravity(object : RigidBody3D):
	if not object: return
	object.gravity_scale = -0.01
	apply_highlight(object, true, highlight_gravity)
	get_tree().create_timer(10).timeout.connect(gravity_finished.bind(object))
	
func gravity_finished(object : RigidBody3D):
	if not object: return
	object.gravity_scale = 1.0
	next_highlight(object, "gravity")

func apply_duplication(object : RigidBody3D, draw_pos : Vector3):
	if not object: return
	var new_object_pos := (draw_pos - object.global_position).normalized()*0.1 + draw_pos
	var duplication := object.duplicate()
	object.add_sibling(duplication)
	duplication.global_position = new_object_pos
	apply_highlight_string(object, true, "duplication")
	
func next_highlight(object, deleted):
	activated_rune_effects[object].erase(deleted)
	apply_highlight(object, false, highlight_duplication)
	print(activated_rune_effects)
	if !activated_rune_effects[object].is_empty():
		apply_highlight_string(object, true, activated_rune_effects[object][-1])

func apply_highlight_string(object, activate, highlight_string):
	match highlight_string:
		"pickable":
			apply_highlight(object, activate, highlight_pickable)
			return 
		"explosion":
			apply_highlight(object, activate, highlight_explosion)
			return 
		"gravity":
			apply_highlight(object, activate, highlight_gravity)
			return 
		"duplication":
			apply_highlight(object, activate, highlight_duplication)
			await get_tree().create_timer(1.0).timeout
			apply_highlight(object, !activate, highlight_duplication)
			return 

func apply_highlight(object, activate, highlight_type):
	var meshes = []
	for c in object.get_children(true):
		if c is MeshInstance3D:
			meshes.append(c)
			continue
		if c.get_children(true) != null:
			apply_highlight(c, activate, highlight_type)
			print("highlight : ", highlight_type)
		
	for m in meshes:
		if activate:
			m.material_overlay = highlight_type
		else: 
			m.material_overlay = null
