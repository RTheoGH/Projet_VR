extends Area3D

@export var idx : int = 0
@onready var parent: Node3D = get_parent()
func activate() -> void:
	if not (parent.last_touched == self):
		get_parent().add_spell_index(self)
	else:
		pass



func _on_wand_tip_entered(_area: Area3D) -> void:
	activate()
