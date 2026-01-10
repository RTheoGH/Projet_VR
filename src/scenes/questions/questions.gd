extends Node3D



# Questions
@onready var age_question : Question = preload("res://src/scenes/questions/resources/question_resources/age_question.tres")

@onready var answer_scene = preload("res://src/scenes/questions/answer_ball.tscn")
@onready var question_label : Label3D = $Question
var questions : Array[Question]
var current_question : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(question_label.text)
	questions.append(age_question)
	set_question(0)

func set_question(question_index : int) :
	
	question_label.text = questions[question_index].question_text
	
	# Clear the current answers (children of Answers)
	
	# Create correct amount of answers
	var answers = questions[question_index].answers
	var nb_answers = len(answers)
	var positions = get_sphere_positions(nb_answers)
	for i in range(nb_answers) : 
		var answer_instance = answer_scene.instantiate()
		answer_instance.position = positions[i]
		add_child(answer_instance)
		answer_instance.create_answer(answers[i])
	# Create an answer area 
	# Fill that area evenly with the answers
	pass
	
func get_sphere_positions(nb_sphere : int , radius : float = 1.0) :
	var center = position
	var margin = radius * 1.25
	
	var positions : Array[Vector3]
	
	var total_width = margin * (nb_sphere - 1)
	var start_offset = -total_width / 2.0
	
	for i in range(nb_sphere) : 
		var x = center.x + start_offset + (margin * i)
		var pos = Vector3(x , center.y , center.z)
		positions.append(pos)
		
	return positions
