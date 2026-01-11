extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var antigrav = load("res://spells/scenes/antigrav.tscn").instantiate()
	$Pont/Planche.add_child(antigrav)
	antigrav.up_bump = 10.0
	antigrav.global_position.y += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
