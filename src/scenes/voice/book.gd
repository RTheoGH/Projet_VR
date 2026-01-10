extends XRToolsPickable
@onready var voice_instance: Node = $Voice

func _on_grabbed(pickable: Variant, by: Variant) -> void:
	if voice_instance != null:
		voice_instance.record()

func _on_dropped(pickable: Variant) -> void:
	if voice_instance != null:
		voice_instance.stop_recording()
