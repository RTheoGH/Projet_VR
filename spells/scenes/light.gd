extends OmniLight3D
var caster: Node3D

var time: float = 10.0

func _start_spell(_dir: Vector3) -> void:
	reparent(caster)
	get_tree().create_timer(time).timeout.connect(
		func ():
			queue_free()
	)
