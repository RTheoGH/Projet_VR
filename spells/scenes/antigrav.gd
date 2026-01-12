extends RigidBody3D

var launch_strength: float = 10.0;
var caster: Node3D
var up_bump = 0.3;

# Called when the node enters the scene tree for the first time.
func _start_spell(dir: Vector3) -> void:
	apply_central_impulse(dir * launch_strength + Vector3.UP * launch_strength / 10.0)
	add_collision_exception_with(caster)
	$cast.play()
	
func expand():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(
		$Area3D/CollisionShape3D2,
		"scale",
		Vector3(1.0, 1.0, 1.0),
		1.0
	).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(
		$Area3D/MeshInstance3D,
		"scale",
		Vector3(1.0, 1.0, 1.0),
		1.0
	).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(
		$MeshInstance3D,
		"scale",
		Vector3(1.0, 1.0, 1.0) * 6.0,
		1.0
	).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	await get_tree().create_timer(5.0).timeout
	tween = get_tree().create_tween()
	tween.tween_property(
		$Area3D/CollisionShape3D2,
		"scale",
		Vector3(0.0, 0.0, 0.0),
		1.0
	).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(
		$Area3D/MeshInstance3D,
		"scale",
		Vector3(0.0, 0.0, 0.0),
		1.0
	).set_trans(Tween.TRANS_CUBIC)
	
	tween.parallel().tween_property(
		$MeshInstance3D,
		"scale",
		Vector3(0.0, 0.0, 0.0),
		1.0
	).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	queue_free()
func _on_body_entered(_body: Node) -> void:
	freeze = true
	$Area3D/CollisionShape3D2.disabled = false
	$CollisionShape3D.disabled = true
	$expand.play()
	expand()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		body.apply_central_impulse(Vector3.UP * up_bump * randf_range(0.9, 1.2))
