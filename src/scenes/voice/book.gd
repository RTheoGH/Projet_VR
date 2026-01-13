@tool
extends XRToolsPickable
@onready var voice_instance: Node = $Voice

func _on_grabbed(_pickable: Variant, _by: Variant) -> void:
	if voice_instance != null:
		voice_instance.record()

func _on_dropped(_pickable: Variant) -> void:
	if voice_instance != null:
		voice_instance.stop_recording()
