extends Node

var activated_rune_effects : Dictionary = {}
signal explosion_signal(from : Vector3, range : float)
const highlight_explosion = preload("res://src/shaders/explosion_highlight_material.tres")
const highlight_pickable = preload("res://src/shaders/pickable_highlight_material.tres")
var highlight_gravity = preload("res://src/shaders/gravity_highlight_material.tres")
var highlight_duplication = preload("res://src/shaders/duplication_highlight_material.tres")

var current_feather: Node3D

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

func apply_pickable(object : RigidBody3D, _draw_pos : Vector3 = Vector3.ZERO):
	if not object: return
	
	apply_highlight(object, true, highlight_pickable)
	object.gravity_scale = 0.0
	current_feather.start_grab(object);


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
	get_tree().create_timer(15).timeout.connect(gravity_finished.bind(object))
	
func gravity_finished(object : RigidBody3D):
	if not object: return
	object.gravity_scale = 1.0
	next_highlight(object, "gravity")

func apply_duplication(object : RigidBody3D, draw_pos : Vector3):
	if not object: return
	var new_object_pos := (draw_pos - object.global_position).normalized()*0.1 + draw_pos
	apply_highlight_string(object, true, "duplication")
	await get_tree().create_timer(1.1).timeout
	var duplication := object.duplicate()
	object.add_sibling(duplication)
	duplication.global_position = new_object_pos
	duplication.scale *= 0
	var t := get_tree().create_tween()
	t.tween_property(duplication, "scale", object.scale, 0.8).set_trans(Tween.TRANS_CIRC)
	
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
		"explosion":
			apply_highlight(object, activate, highlight_explosion)
		"gravity":
			apply_highlight(object, activate, highlight_gravity)
		"duplication":
			apply_highlight(object, activate, highlight_duplication)
			await get_tree().create_timer(1.0).timeout
			apply_highlight(object, !activate, highlight_duplication)

func apply_highlight(object, activate: bool, highlight_type):
	
	var meshes = []
	for c in object.get_children(true):
		if c is MeshInstance3D:
			meshes.append(c)
			continue
		if c.get_children(true) != null:
			apply_highlight(c, activate, highlight_type)
			#print("highlight : ", highlight_type)
		
	for m in meshes:
		if activate:
			m.material_overlay = highlight_type
		else: 
			m.material_overlay = null
