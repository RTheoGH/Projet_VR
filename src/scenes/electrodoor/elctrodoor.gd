extends Node3D

@onready var animation_player: AnimationPlayer = $generator/AnimationPlayer
@onready var door: Node3D = $door
var activated: bool = false
const opening_height := 2.2
func activate():
	if activated: return
	activated = true
	animation_player.play("run")
	
	var t := get_tree().create_tween()
	t.tween_property(door, "global_position:y", door.global_position.y + opening_height, 2.0
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	

#func _ready():
	#await get_tree().create_timer(2.0).timeout
	#
	#$Thunderbolt.explode()
