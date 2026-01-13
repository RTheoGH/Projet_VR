extends Node3D

#var mxw : Tween

@export var player : XROrigin3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#maxwell()
	Gamemaster.musicTween = get_tree().create_tween()
	Gamemaster.musicTween.tween_property(
		Gamemaster.hub_ambience,
		"volume_linear",
		1.0,
		3.5
	)
	Gamemaster.fade_to_black(0)
	Gamemaster.fade_from_black(4.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#func maxwell():
	#if mxw:
		#mxw.kill()
	#
	#mxw = create_tween()
	#mxw.set_loops()
	#mxw.tween_property($Interieur/maxwell, "rotation_degrees:z", -30, 0.2)
	#mxw.tween_property($Interieur/maxwell, "rotation_degrees:z", 30, 0.2)
	#mxw.tween_property($Interieur/maxwell, "rotation_degrees:z", 30, 0.2)
	#mxw.tween_property($Interieur/maxwell, "rotation_degrees:z", -30, 0.2)

func goto_hub(node: Node) -> void:
	if node == player:
		player.position = Vector3(0.0,0.0,0.0)
		$portal_sound.play()

#func _portal1_entered(node: Node) -> void:
	#if node == player:
		#player.position = $Zone1.position
		#$portal_sound.play()
#
#func _portal2_entered(node: Node) -> void:
	#if node == player:
		#player.position = $Zone2.position
		#$portal_sound.play()
#
#func _portal3_entered(node: Node) -> void:
	#if node == player:
		#player.position = $Zone3.position
		#$portal_sound.play()

func _start_levels(node: Node) -> void:
	if node == player:
		$portal_sound.play()
		#Gamemaster.random_level_tp() // a changer
		#get_tree().change_scene_to_packed(load("res://src/levels/level_balls/level_balls.tscn"))
