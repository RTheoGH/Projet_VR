@tool
extends XRToolsPickable

const MAGE_BALL_CIRCLE = preload("uid://bfs5qsy4dw1iq")

func _process(delta: float):
	$testSphere.global_position = -$tip.global_basis.z * 3.0

var circle: Node3D
func activate_touched(pressed: bool):
	if pressed: 
		circle = MAGE_BALL_CIRCLE.instantiate()
		
		get_tree().get_root().add_child(circle)
		circle.global_transform = $tip.global_transform
	elif circle:
		circle.destroy()

func activate(_pressed: bool):
	if circle:
		circle.finish_spell($tip.global_position, (-$tip.global_basis.z).normalized(), self)
