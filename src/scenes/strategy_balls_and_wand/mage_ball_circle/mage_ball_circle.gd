extends Node3D

@export var number_of_balls: int = 7
@export var dist_to_center: float = 1.0
const MAGE_BALL = preload("uid://bmn3qb23bx2l5")

var spellbook : Dictionary[String, Spell] = {
	"0240": preload("res://spells/resources/fireball.tres"),
	"0": preload("res://spells/resources/fireball.tres")
}

var spell_buffer: String = ""
var last_touched: Node3D = null
var currently_launching := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in number_of_balls:
		var angle := 2.0 * PI / number_of_balls * i
		
		var vec = (Vector3.DOWN * dist_to_center).rotated(Vector3.FORWARD, angle)
		
		var ball := MAGE_BALL.instantiate()
		ball.idx = i
		add_child(ball)
		ball.position += vec

func get_spell(spell_string : String) -> Spell:
	if spellbook.has(spell_string):
		return spellbook[spell_string]
	else: 
		return null

func start_spell() -> void:
	spell_buffer = ""
	currently_launching = true
	

func finish_spell() -> void:
	var spell: Spell = get_spell(spell_buffer)
	if spell:
		print("Launched " + spell.name)
		spell.launch(global_transform, self) #TODO devrait plutot etre le character que self
	else:
		print("Spell pas valide")
	

func add_spell_index(ball: Node3D):
	last_touched = ball
	spell_buffer += str(ball.idx)
	print(spell_buffer)
	
	$finish.visible = spellbook.has(spell_buffer)
	$finish/CollisionShape3D.disabled = not spellbook.has(spell_buffer)


func _on_finish_body_entered(body: Node3D) -> void:
	finish_spell()
