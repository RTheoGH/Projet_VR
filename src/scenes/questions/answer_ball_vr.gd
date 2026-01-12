@tool
extends XRToolsPickable

var value : String

@onready var label : Label3D = $AnswerLabel
@onready var area : Area3D = $Area3D
@onready var selectable : XRToolsPickable = self

var target_position : Vector3
var fly_towards_target : bool = true

func _physics_process(_delta: float) -> void:
	
	if fly_towards_target :
		var dir := (target_position - global_position)
		selectable.apply_central_force(dir * 6)
			
func create_answer(answer_res : Answer) -> void :
	label.text = str(answer_res.value_text)
	value = answer_res.value




# a bit spaghettesque but just makes sure the balls behavior changes at the right time 
# only if nothing happened (like a regrab)
func set_un_grabbed():
	fly_towards_target = true
	gravity_scale = 0
	linear_damp = 2
	
	if timer.timeout.is_connected(set_un_grabbed):
		timer.timeout.disconnect(set_un_grabbed)
	timer.start(3.0)
	timer.timeout.connect(tp_if_far)
	
func tp_if_far():
	if global_position.distance_squared_to(target_position) > 0.3:
		linear_velocity = Vector3.ZERO
		global_position = target_position
		
	if timer.timeout.is_connected(tp_if_far):
		timer.timeout.disconnect(tp_if_far)
		
@onready var timer: Timer = $Timer
func _on_grabbed(_pickable: Variant, _by: Variant) -> void:
	fly_towards_target = false
	gravity_scale = 1
	linear_damp = 0
	if timer.timeout.is_connected(tp_if_far):
		timer.timeout.disconnect(tp_if_far)
	if timer.timeout.is_connected(set_un_grabbed):
		timer.timeout.disconnect(set_un_grabbed)
	timer.stop()



func _on_dropped(_pickable: Variant) -> void:
	timer.start(6.0)
	timer.timeout.connect(set_un_grabbed)
