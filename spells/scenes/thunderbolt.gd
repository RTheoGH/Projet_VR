extends Node3D

var caster: Node3D
var explode_strength = 7.0;

# Called when the node enters the scene tree for the first time.
func _start_spell() -> void:
	var ray : RayCast3D = caster.get_node("tip/RayCast3D")
	if ray:
		var collision_point = ray.get_collision_point()
		if ray.get_collider():
			print("brzzzzz")
			global_position = collision_point
			global_position.y -= 5
			$GPUParticles3D.emitting = true
		else:
			global_position = caster.global_position + to_global(Vector3.FORWARD * 10.0)
			global_position.y -= 5
			$GPUParticles3D.emitting = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	#await get_tree().create_timer(13).timeout
	#$GPUParticles3D.emitting = true
	if body is RigidBody3D and $GPUParticles3D.emitting :
		var explode_zone : Vector3 = $Area3D/CollisionShape3D2.global_position
		var dist_sq: float = (body.global_position).distance_squared_to(explode_zone)
		body.apply_central_impulse((body.global_position - explode_zone) * explode_strength)
		HitManager.hit_body(body, explode_strength / dist_sq)


func _on_gpu_particles_3d_finished() -> void:
	queue_free()
