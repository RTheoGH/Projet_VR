extends Node

var activated_rune_effects : Dictionary = {}

func apply_effect_on_object(object : RigidBody3D, effect : String):
	activated_rune_effects[object] = effect

func apply_holdable(object : RigidBody3D):
	var xr_pickable := XRToolsPickable.new()
	xr_pickable.add_child(object)
	var left_hand = XRToolsGrabPointHand.new()
	var right_hand = XRToolsGrabPointHand.new()
	right_hand.hand = XRToolsGrabPointHand.Hand.RIGHT
	xr_pickable.add_child(XRToolsGrabPointHand.new())
	get_tree().create_timer(15).timeout.connect(holdable_finished)
	
func holdable_finished():
	pass
