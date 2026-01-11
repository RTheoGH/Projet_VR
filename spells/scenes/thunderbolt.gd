extends Node3D

var caster: Node3D
var explode_strength = 7.0;

# Called when the node enters the scene tree for the first time.
func _start_spell() -> void:
	print(caster)
	
	var ray : RayCast3D = caster.get_node("tip/RayCast3D")

	
	if ray:
		var collision_point = ray.get_collision_point()
		if ray.get_collider():
			print("brzzzzz")
			global_position = collision_point
			global_position.y -= 5
			explode()
		else:
			print(global_position)
			global_position = caster.global_position + to_global(Vector3.FORWARD * 10.0)
			global_position.y -= 5
			explode()
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var area_3d: Area3D = $Area3D
@onready var impact: AudioStreamPlayer3D = $impact

func explode():
	impact.play()
	$GPUParticles3D.emitting = true
	var t := get_tree().create_tween()
	t.tween_property(omni_light_3d, "light_energy", 1000.0, 0.1)
	t.tween_property(omni_light_3d, "light_energy", 0.0, 0.15)
	var explode_zone : Vector3 = $Area3D/CollisionShape3D2.global_position
	for body in area_3d.get_overlapping_bodies():
		if body is RigidBody3D:
			var dist_sq: float = (body.global_position).distance_squared_to(explode_zone)
			body.apply_central_impulse((body.global_position - explode_zone) * explode_strength)
			HitManager.hit_body(body, explode_strength / dist_sq)
		if body.is_in_group("electric_device"):
			body.activate()

func _on_gpu_particles_3d_finished() -> void:
	pass

func _on_impact_finished() -> void:
	queue_free()
