extends Control

var player: Node3D
func _ready():
	levels_permutation.shuffle()
	#just a cool fadein of the ambience
	hub_ambience.volume_db = -80 
	music_lerp_value = 0.0
	#test()


func test():
	
	await musicTween.finished
	await nextLevel()
	await get_tree().create_timer(2.5).timeout
	await nextLevel()
	await get_tree().create_timer(2.5).timeout
	await nextLevel()
	await get_tree().create_timer(2.5).timeout
	await nextLevel()
	await get_tree().create_timer(2.5).timeout
#################

var fadeTween: Tween
func fade_to_black(time:float):
	if not is_instance_valid(player):
		return
	var fade_rect: MeshInstance3D = player.fade_rect
	if time <= 0:
		fade_rect.show()
		fade_rect.material_override.albedo_color.a = 1.0
		fadeTween = null
	else:
		fade_rect.show()
		fadeTween = get_tree().create_tween()
		fadeTween.tween_property(
			fade_rect.material_override,
			"albedo_color:a",
			1.0,
			time
		)
		await fadeTween.finished
	return

func fade_from_black(time:float) -> void:
	if not is_instance_valid(player):
		return
	var fade_rect: MeshInstance3D = player.fade_rect
	if time <= 0:
		fade_rect.material_override.albedo_color.a = 0.0
		fade_rect.hide()
		fadeTween = null
	else:
		fadeTween = get_tree().create_tween()
		fadeTween.tween_property(
			fade_rect.material_override,
			"albedo_color:a",
			0.0,
			time
		)
		await fadeTween.finished
		if is_instance_valid(fade_rect):
			fade_rect.hide()
		
	return 

@onready var dungeon_music: AudioStreamPlayer = $DungeonMusic
@onready var hub_ambience: AudioStreamPlayer = $HubAmbience

var music_lerp_value:= 0.0: # 0 = only hub ambience, 1 = only dungeon music
	set(v):
		music_lerp_value = v
		dungeon_music.volume_linear = v
		hub_ambience.volume_linear 	= 0.9- v * 0.9
		
var musicTween: Tween
func fade_to_ambience():
	musicTween = get_tree().create_tween()
	musicTween.tween_property(
		self,
		"music_lerp_value",
		0.0,
		3.5
	)
	await musicTween.finished
	return

func fade_to_music() -> void:
	musicTween = get_tree().create_tween()
	musicTween.tween_property(
		self,
		"music_lerp_value",
		1.0,
		3.5
	)
	await musicTween.finished
	return 
	

var hub: PackedScene = preload("res://src/levels/hub.tscn")
var levels: Array[PackedScene] = [
	#preload("res://src/levels/level_balls/level_balls.tscn"),
	#preload("res://src/levels/level_book/level_book.tscn"),
	preload("res://src/levels/level_feather/level_feather.tscn"),
	preload("res://src/levels/level_feather/level_feather.tscn"),
	preload("res://src/levels/level_feather/level_feather.tscn")
]
var levels_permutation = [0,1,2]
var current_level_index:int = -1 # -1 is the hub

# never call that directly. The gamemaster decides the order. Call nextLevel()
func load_level(index: int) -> void:
	if current_level_index == index: return
	var level := levels[levels_permutation[index]]
	fade_to_music()
	await fade_to_black(1.0)
	get_tree().change_scene_to_packed(level)
	current_level_index = index
	await fade_from_black(1.5)
	return

################# Only call those

func load_hub() -> void:
	if current_level_index == -1: return
	fade_to_ambience()
	await fade_to_black(1.0)
	get_tree().change_scene_to_packed(hub)
	current_level_index = -1
	await fade_from_black(1.5)
	return 

# starts the first level, goes back to hub after the last one, etc
func nextLevel() -> void:
	if current_level_index >= 2:
		await load_hub()
	else:
		await load_level(current_level_index+1)
	return
	
func get_ui_viewport_texture() -> ViewportTexture:
	return ($SubViewport as SubViewport).get_texture()

func jail():
	load_hub()
	var pos: Vector3 = get_tree().get_nodes_in_group("maxcage").pick_random().global_position
	player.global_position = pos + 1.0 * Vector3.UP
