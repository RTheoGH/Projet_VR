extends Node3D


func _on_hit_manager_hurt(val: float) -> void:
	var dir:Vector3 = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	print("OUCH (damage ", val, ")")
	$Dummy2/Dummy.apply_central_impulse(dir * val)


func _on_hit_manager_dead(neg_val: float) -> void:
	pass # Replace with function body.
