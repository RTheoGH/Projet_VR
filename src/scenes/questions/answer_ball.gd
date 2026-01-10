extends Node3D

var value : String

@onready var label : Label3D = $AnswerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func create_answer(answer_res : Answer) -> void :
	print("Good morning : " , answer_res.value_text)
	label.text = str(answer_res.value_text)
	value = answer_res.value	

func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
