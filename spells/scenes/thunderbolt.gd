extends Node3D

var caster: Node3D
var explode_strength = 7.0;

# Called when the node enters the scene tree for the first time.
func _start_spell() -> void:
	$GPUParticles3D.emitting = true
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	var explode_zone : Vector3 = $Area3D/CollisionShape3D2.global_position
	var dist_sq: float = (body.global_position).distance_squared_to(explode_zone)
	body.apply_central_impulse((body.global_position - explode_zone) * explode_strength)
	HitManager.hit_body(body, explode_strength / dist_sq)


func _on_gpu_particles_3d_finished() -> void:
	queue_free()
