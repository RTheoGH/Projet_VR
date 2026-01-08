extends Node

var activated_rune_effects : Dictionary = {}

func apply_effect_on_object(draw_pos : Vector3, object : RigidBody3D, effect : String):
	activated_rune_effects[object] = effect

func apply_pickable(object : RigidBody3D):
	var xr_pickable := XRToolsPickable.new()
	xr_pickable.add_child(object)
	var left_hand = XRToolsGrabPointHand.new()
	left_hand.hand = XRToolsGrabPointHand.Hand.LEFT
	var right_hand = XRToolsGrabPointHand.new()
	right_hand.hand = XRToolsGrabPointHand.Hand.RIGHT
	xr_pickable.add_child(XRToolsGrabPointHand.new())
	get_tree().create_timer(15).timeout.connect(pickable_finished.bind(object))
	print(object.get_parent())
	
func pickable_finished(object : RigidBody3D):
	var xr_pickable = object.get_parent()
	object.add_child(xr_pickable)
	xr_pickable.queue_free()
	
