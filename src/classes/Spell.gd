extends Resource
class_name Spell
@export var name: StringName
@export var scene: PackedScene

func launch(from_transform: Transform3D, launched_by: Node3D):
		var new_scene: Node3D = scene.instantiate()
		
		launched_by.get_tree().get_root().add_child(new_scene)
		new_scene.global_transform = from_transform
		new_scene.caster = launched_by
