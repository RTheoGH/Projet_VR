extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $CharacterBody3D/skeleton/AnimationPlayer
@onready var skeleton: Node3D = $skeleton

var speed: float = 1.0
var hit_distance: float = 1.5
var fuck_chance := 0.1
func _on_hit_manager_hurt(val: float) -> void:
	pass


func _on_hit_manager_dead(neg_val: float) -> void:
	queue_free()

func attack():
	GameMaster.hurt_player(10.0)

func _ready() -> void:
	animation_player.play(&"skeleton-skeleton|spawn")


func _process(delta: float) -> void:
	if not GameMaster.player: return
	
	if animation_player.current_animation == &"skeleton-skeleton|spawn":
		return
	
	if animation_player.current_animation == &"skeleton-skeleton|taunt":
		pass
	
	var d: float = GameMaster.player.global_position.distance_to(global_position)
	
	if d < hit_distance:
		if animation_player.current_animation != &"skeleton-skeleton|attack":
			velocity = Vector3.ZERO
			attack();
	else:
		velocity = (GameMaster.player.global_position - global_position) / d * speed * delta
	
	move_and_collide(velocity)
	skeleton.look_at(global_position + velocity, Vector3.UP)
	
	if (randf_range(0.0, 1.0) <= fuck_chance * delta):
		animation_player.play(&"skeleton-skeleton|taunt")
