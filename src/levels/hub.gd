extends Node3D

var mxw : Tween

@export var player : XROrigin3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxwell()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func maxwell():
	if mxw:
		mxw.kill()
	
	mxw = create_tween()
	mxw.set_loops()
	mxw.tween_property($Interieur/maxwell, "rotation_degrees:z", -30, 0.2)
	mxw.tween_property($Interieur/maxwell, "rotation_degrees:z", 30, 0.2)
	mxw.tween_property($Interieur/maxwell, "rotation_degrees:z", 30, 0.2)
	mxw.tween_property($Interieur/maxwell, "rotation_degrees:z", -30, 0.2)

func goto_hub(node: Node) -> void:
	if node == player:
		player.position = Vector3(0.0,0.0,0.0)

func _portal1_entered(node: Node) -> void:
	if node == player:
		player.position = $Zone1.position

func _portal2_entered(node: Node) -> void:
	if node == player:
		player.position = $Zone2.position

func _portal3_entered(node: Node) -> void:
	if node == player:
		player.position = $Zone3.position
