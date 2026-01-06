extends Node3D

@export var number_of_balls: int = 7
@export var dist_to_center: float = 0.3
const MAGE_BALL = preload("uid://bmn3qb23bx2l5")

var spellbook : Dictionary[String, Spell] = {
	"0430": preload("res://spells/resources/light.tres"),
	"62516": preload("res://spells/resources/fireball.tres"),
	"5104":  preload("res://spells/resources/antigrav.tres"),
	"3641250" : preload("res://spells/resources/thunderbolt.tres")
}

var spell_buffer: String = ""
var last_touched: Node3D = null
var currently_launching := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$links.mesh.clear_surfaces()
	for i in number_of_balls:
		var angle := 2.0 * PI / number_of_balls * i
		
		var vec = (Vector3.DOWN * dist_to_center).rotated(Vector3.FORWARD, angle)
		
		var ball := MAGE_BALL.instantiate()
		ball.idx = i
		add_child(ball)
		ball.position += vec
	
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	

func get_spell(spell_string : String) -> Spell:
	if spellbook.has(spell_string):
		return spellbook[spell_string]
	else: 
		return null

func start_spell() -> void:
	spell_buffer = ""
	currently_launching = true
	

func finish_spell(launch_transform: Transform3D, caster: Node3D) -> void:
	var spell: Spell = get_spell(spell_buffer)
	if spell:
		print("Launched " + spell.name)
		spell.launch(launch_transform, caster)
	else:
		print("Spell pas valide")
	
	queue_free()

func destroy():
	queue_free()

func add_spell_index(ball: Node3D):
	if last_touched:
		add_face(last_touched.position, ball.position)
	
	last_touched = ball
	spell_buffer += str(ball.idx)
	print(spell_buffer)
	
	#$finish.visible = spellbook.has(spell_buffer)
	#$finish/CollisionShape3D.disabled = not spellbook.has(spell_buffer)


func _on_finish_body_entered(body: Node3D) -> void:
	#finish_spell()
	pass

func add_face(start: Vector3, end: Vector3):
	var mesh: ImmediateMesh = $links.mesh
	
	var trail: Vector3 = end - start
	var direction: Vector3 = trail.normalized()
	var distance: float = trail.length()
	var dir90: Vector3 = direction.rotated(-Vector3.FORWARD, PI/2)

	var thickness: float = 0.02

	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)

	var d: Vector3 = distance * direction
	# starts
	mesh.surface_set_normal(Vector3.FORWARD)
	mesh.surface_set_uv(Vector2(0.0, 0.0))
	mesh.surface_add_vertex(start - (thickness * dir90))

	mesh.surface_set_normal(Vector3.FORWARD)
	mesh.surface_set_uv(Vector2(0.0, 1.0))
	mesh.surface_add_vertex(start + (thickness * dir90))
	
	# end
	mesh.surface_set_normal(Vector3.FORWARD)
	mesh.surface_set_uv(Vector2(1.0, 0.0))
	mesh.surface_add_vertex(end - (thickness * dir90))

	mesh.surface_set_normal(Vector3.FORWARD)
	mesh.surface_set_uv(Vector2(1.0, 1.0))
	mesh.surface_add_vertex(end + (thickness * dir90))

	mesh.surface_end()

 ## Pour tester le lancement des sorts
func _on_node_3d_tree_entered() -> void:
	await get_tree().create_timer(3).timeout
	spell_buffer = "3641250"
	finish_spell($"../Node3D".get_node("tip").global_transform, $"../Node3D")
