extends Node

var activated_rune_effects : Dictionary = {}
signal explosion_signal(from : Vector3, range : float)

func apply_effect_on_object(draw_pos : Vector3, object : RigidBody3D, effect : String):
	if object == null:
		return
	if activated_rune_effects.keys().has(object) :
		activated_rune_effects[object].append(effect)
	else :
		activated_rune_effects[object] = [effect]
		
	match effect:
		"pickable":
			apply_pickable(object, draw_pos)
			return
		"explosion":
			apply_explosion(object, draw_pos)
			return
		"gravity":
			apply_gravity(object)
			return
		"duplication":
			apply_duplication(object, draw_pos)

func apply_pickable(object : RigidBody3D, draw_pos : Vector3 = Vector3.ZERO):
	if not object: return
	var xr_pickable := XRToolsPickable.new()
	print(object)
	var object_pos := object.global_position
	object.replace_by(xr_pickable)
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
	
	#get_tree().create_timer(15).timeout.connect(pickable_finished.bind(xr_pickable, object, left_hand, right_hand))
	
func pickable_finished(object : RigidBody3D, previous_object : RigidBody3D, left_hand : XRToolsGrabPointHand, right_hand : XRToolsGrabPointHand):
	if not object: return
	activated_rune_effects[previous_object].erase("pickable")
	print(activated_rune_effects)
	object.replace_by(previous_object)
	left_hand.queue_free()
	right_hand.queue_free()
	object.free()

func apply_explosion(object : RigidBody3D, draw_pos : Vector3):
	if not object: return
	get_tree().create_timer(5).timeout.connect(explosion_finished.bind(object, draw_pos))

func explosion_finished(object : RigidBody3D, draw_pos : Vector3):
	if not object: return
	object.apply_central_impulse((draw_pos - object.global_position).normalized() * 5.0)
	explosion_signal.emit(draw_pos, 2.0)
	var explosion_scene = load("res://spells/scenes/explosion.tscn").instantiate()
	object.add_child(explosion_scene)
	explosion_scene.scale = object.scale
	# object.queue_free() ?

func apply_gravity(object : RigidBody3D):
	if not object: return
	object.gravity_scale = -0.01
	get_tree().create_timer(10).timeout.connect(gravity_finished.bind(object))

func gravity_finished(object : RigidBody3D):
	if not object: return
	object.gravity_scale = 1.0

func apply_duplication(object : RigidBody3D, draw_pos : Vector3):
	if not object: return
	var new_object_pos := (draw_pos - object.global_position).normalized()*0.1 + draw_pos
	var duplication := object.duplicate()
	object.add_sibling(duplication)
	duplication.global_position = new_object_pos
