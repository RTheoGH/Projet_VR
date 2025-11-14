extends Camera3D

func _ready():
	test()

func test():
	await get_tree().process_frame
	var balles = []

	for i in 7:
		var angle := 2.0 * PI / 7 * i
		
		var vec = (Vector3.DOWN * 0.3).rotated(Vector3.FORWARD, angle)	
		balles.push_back(vec)
		
	$"..".add_face(balles[0], balles[1])
