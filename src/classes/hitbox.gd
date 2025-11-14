extends Node3D
class_name HitManager

signal hurt(val: float)
signal heal(val: float)
signal dead(neg_val: float)

var max_hp: float = 100.0
var current_hp = max_hp

@export var linked_body: PhysicsBody3D

@export var show_hp: bool = true

func _ready() -> void:
	if show_hp:
		pass # TODO instantiate hp bar
	
	if linked_body:
		linked_body.set_meta("HitManager", self)

func apply_damage(damage: float) -> bool:
	current_hp -= damage
	if current_hp <= 0:
		dead.emit(-current_hp)
		return true
	else:
		hurt.emit(damage)
		return false

func apply_heal(heal_val: float) -> void:
	current_hp = min(current_hp + heal_val, max_hp)
	heal.emit(heal_val)


# this is the function to call. It's static !!
static func hit_body(body: PhysicsBody3D, damage: float) -> bool:
	if body.has_meta("HitManager"):
		return body.get_meta("HitManager").apply_damage(damage)
	return false
