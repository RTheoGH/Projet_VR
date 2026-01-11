@tool
extends Node3D


@export var color:Color:
	set(v):
		color = v
		if portal_door_material == null: return
		portal_door_material.set_shader_parameter("Portal_Color", v)
		portal_particle_material.albedo_color = v * 4.0
		omni_light_3d.light_color = v
@export var deactivated := false:
	set(v):
		deactivated = v
		collision_shape_3d.disabled = v
		node_3d.visible = !v
		
@export var use_override_instead_of_next:bool = false
@export var override_destination:int = 0

@onready var omni_light_3d: OmniLight3D = $OmniLight3D

@onready var area_3d: Area3D = $Area3D
@onready var portal_door_material: ShaderMaterial = $Node3D/PortalDoor.material_override
@onready var portal_particle_material: StandardMaterial3D = $Node3D/GPUParticles3D.material_override
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var node_3d: Node3D = $Node3D

func _ready():
	color = color

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !body.is_in_group("player"): return
	
	if not use_override_instead_of_next: 
		Gamemaster.nextLevel()
	else:
		Gamemaster.load_level(override_destination)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if !area.is_in_group("player"): return
	
	if not use_override_instead_of_next: 
		Gamemaster.nextLevel()
	else:
		Gamemaster.load_level(override_destination)
