extends Node3D




# @onready var answer_scene = preload("res://src/scenes/questions/answer_ball.tscn")
@onready var answer_scene = preload("res://src/scenes/questions/answer_ball_vr.tscn")
@onready var question_label : Label3D = $Question
@onready var answers_node : Node3D = $Answers
@export var questions : Array[Question]
var current_question : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_question(0)

func set_question(question_index : int) :
	
	question_label.text = questions[question_index].question_text
	
	# Clear the current answers (children of Answers)
	
	for child in answers_node.get_children() : 
		answers_node.remove_child.call_deferred(child)
		child.queue_free()
	
	# Create correct amount of answers
	var answers = questions[question_index].answers
	var nb_answers = len(answers)
	var positions = get_sphere_positions(nb_answers)
	
	await wait(0.3)
	
	for i in range(nb_answers) : 
		var answer_instance = answer_scene.instantiate()

		answers_node.add_child(answer_instance)
		
		answer_instance.position = positions[i]
		answer_instance.target_position = to_global(positions[i])
		
		answer_instance.create_answer(answers[i])
		
		answer_instance.area.area_entered.connect(
			func(_area: Area3D) :
				if _area.is_in_group("Cauldron") :
					answer_selected(i)
		)
		
		# answer_instance.selectable.grabbed.connect(
		# 	func(_pickable : Variant, by:Variant) :
		# 		answer_selected(by , i)
		# )

func get_sphere_positions(nb_sphere : int , radius : float = 0.25) :
	var center = answers_node.position
	var margin = radius * 1.25
	
	var positions : Array[Vector3]
	
	var total_width = margin * (nb_sphere - 1)
	var start_offset = -total_width / 2.0
	
	for i in range(nb_sphere) : 
		var x = center.z + start_offset + (margin * i)
		var pos = Vector3(x , center.y , center.z)
		print(center)
		positions.append(pos)
		
	return positions
	
func answer_selected(answer_index : int) : 
		
	var selected_answer= questions[current_question].answers[answer_index]
	add_to_db(selected_answer)

	if current_question+1 < len(questions):
		current_question += 1
		set_question(current_question)
		
	else : 
		queue_free()

func add_to_db(selected_answer : Answer):
	var value = selected_answer.value
	var column = questions[current_question].sql_column
	if column == "": return
	
	Analytics.set_value("player", column, value)
	
func wait(seconds: float) -> void:	
	print("Wait")
	await get_tree().create_timer(seconds).timeout


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("maxwell"):
		Gamemaster.jail()
		body.queue_free()
