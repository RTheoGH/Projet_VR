extends XRToolsPickable

var value : String

@onready var label : Label3D = $AnswerLabel
@onready var area : Area3D = $Area3D
@onready var selectable : XRToolsPickable = self

var target_position : Vector3
var fly_towards_target : bool = true

func _physics_process(delta: float) -> void:
	
	var offset_target := target_position + Vector3.UP * cos(Time.get_ticks_msec() * 0.001 + target_position.length_squared()) * 0.01
	
	if fly_towards_target :
		var dir := (target_position - global_position)
		var d = max(dir.length_squared() , 0.1)
		selectable.apply_central_force(dir * 10)
			
func create_answer(answer_res : Answer) -> void :
	print("Good morning : " , answer_res.value_text)
	label.text = str(answer_res.value_text)
	value = answer_res.value

func _on_selectable_grabbed(pickable: Variant, by: Variant) -> void:
	fly_towards_target = false
	gravity_scale = 1
	linear_damp = 0

func _on_selectable_dropped(pickable: Variant) -> void:
	get_tree().create_timer(2).timeout.connect(
		func() :
			fly_towards_target = true
			gravity_scale = 0
			linear_damp = 2
	)
	
