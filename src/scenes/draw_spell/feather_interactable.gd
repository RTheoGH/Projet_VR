extends XRToolsPickable

var ink_decal = preload("res://src/scenes/draw_spell/ink_decal.tscn")
var is_drawing = false
var can_draw = false

var max_decals = 50 # Technically can have more but it is counted with some types of lights so idk i'll limit it
var active_decals : Array[Decal]
var collision_body : Node3D


func _physics_process(delta: float) -> void:
	if is_drawing and can_draw :
		draw_point(collision_body)

func draw_point(body: Node3D):
		if(active_decals.size() >= max_decals):
			active_decals.pop_front().queue_free()
			
		var ink = ink_decal.instantiate()
		ink.position = body.global_position
		print("ink position : " , ink.position)
		active_decals.append(ink)
		add_child(ink)
		
func activate(_pressed: bool):
	is_drawing = true
	

func _on_tip_body_entered(body: Node3D) -> void:
	#FIXME test actual conditions and see wagwan
	if body != self:
		can_draw = true
		collision_body = body
