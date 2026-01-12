extends XROrigin3D

@onready var la_boule = $controller_r/RightPhysicsHand/Draw
@onready var full_screen_quad: MeshInstance3D = $FullScreenQuad

func _ready() -> void:
	Gamemaster.player = self
	la_boule.visible = false
	full_screen_quad.material_override.set_shader_parameter(
		"ui_tex",
		Gamemaster.get_ui_viewport_texture()
	)

func _process(delta: float) -> void:
	if Input.is_action_pressed("up_cam"):
		$XRCamera3D.rotate_x(delta)
	if Input.is_action_pressed("down_cam"):
		$XRCamera3D.rotate_x(-delta)


	if Input.is_action_pressed("toggle_drawing"):
		la_boule.visible = true
		
	if Input.is_action_just_pressed("toggle_drawing"):
		print("je veux dessiner")
		la_boule.get_node("CollisionShape3D").disabled = false
		print(la_boule.get_node("CollisionShape3D").disabled)
	if Input.is_action_just_released("toggle_drawing"):
		la_boule.visible = false
		la_boule.get_node("CollisionShape3D").disabled = true
		print("j'ai plus envie")
		print(la_boule.get_node("CollisionShape3D").disabled)
