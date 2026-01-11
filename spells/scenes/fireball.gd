extends RigidBody3D

var launch_strength: float = 10.0;
var caster: Node3D
var explode_strength = 10.0;

var explosion = preload("res://spells/scenes/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _start_spell(dir: Vector3) -> void:
	$cast.play()
	apply_central_impulse(to_global(dir * launch_strength))
	#add_collision_exception_with(caster)
	
func explode():
	for b in $Area3D.get_overlapping_bodies():
		if b is RigidBody3D:
			var dist_sq: float = (b.global_position).distance_squared_to(global_position)
			b.apply_central_impulse((b.global_position - global_position) * explode_strength)
			HitManager.hit_body(b, explode_strength / dist_sq)
	var effect = explosion.instantiate()
	effect.position = position
	get_parent().add_child(effect)
	effect.get_node("explode").play()
	queue_free()

func _on_body_entered(body: Node) -> void:
	explode()
	print("boum")
