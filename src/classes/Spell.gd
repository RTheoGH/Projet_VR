extends Resource
class_name Spell
@export var name: StringName
@export var scene: PackedScene

func launch(pos: Vector3, dir: Vector3, launched_by: Node3D):
		var new_scene: Node3D = scene.instantiate()
		
		launched_by.get_tree().get_root().add_child(new_scene)
		new_scene.caster = launched_by
		new_scene.global_position = pos
		new_scene._start_spell(dir)
