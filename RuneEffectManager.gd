extends Node

var activated_rune_effects : Dictionary = {}

func apply_effect_on_object(draw_pos : Vector3, object : RigidBody3D, effect : String):
	if activated_rune_effects.keys().has(object) :
		activated_rune_effects[object].append(effect)
	else :
		activated_rune_effects[object] = [effect]
		
	match effect:
		"grab":
			apply_pickable(object, draw_pos)
			return
		"explosion":
			apply_explosion(object)
			return
		"gravity":
			apply_gravity(object)
			return
		"duplication":
			apply_duplication(object)

func apply_pickable(object : RigidBody3D, position : Vector3 = Vector3.ZERO):
	var xr_pickable := XRToolsPickable.new()
	xr_pickable.global_position = object.global_position
	object.replace_by(xr_pickable)
	# changer pos des mains ici
	var left_hand = XRToolsGrabPointHand.new()
	left_hand.hand = XRToolsGrabPointHand.Hand.LEFT
	var right_hand = XRToolsGrabPointHand.new()
	right_hand.hand = XRToolsGrabPointHand.Hand.RIGHT
	xr_pickable.add_child(XRToolsGrabPointHand.new())
	get_tree().create_timer(15).timeout.connect(pickable_finished.bind(xr_pickable, object, left_hand, right_hand))
	
func pickable_finished(object : RigidBody3D, previous_object : RigidBody3D, left_hand : XRToolsGrabPointHand, right_hand : XRToolsGrabPointHand):
	activated_rune_effects[previous_object].erase("pickable")
	print(activated_rune_effects)
	object.replace_by(previous_object)
	left_hand.queue_free()
	right_hand.queue_free()
	object.free()
	
	
func apply_explosion(object : RigidBody3D):
	pass

func apply_gravity(object : RigidBody3D):
	object.gravity_scale = -0.01
	get_tree().create_timer(10).timeout.connect(gravity_finished.bind(object))

func gravity_finished(object : RigidBody3D):
	object.gravity_scale = 1.0

func apply_duplication(object : RigidBody3D):
	pass
