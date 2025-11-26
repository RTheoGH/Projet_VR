extends Node3D

var mxw : Tween

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
	mxw.tween_property($maxwell, "rotation_degrees:z", -30, 0.2)
	mxw.tween_property($maxwell, "rotation_degrees:z", 30, 0.2)
	mxw.tween_property($maxwell, "rotation_degrees:z", 30, 0.2)
	mxw.tween_property($maxwell, "rotation_degrees:z", -30, 0.2)
