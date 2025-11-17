extends OmniLight3D
var caster: Node3D

var time: float = 5.0

func _start_spell() -> void:
	reparent(caster)
	get_tree().create_timer(time).timeout.connect(
		func ():
			queue_free()
	)
