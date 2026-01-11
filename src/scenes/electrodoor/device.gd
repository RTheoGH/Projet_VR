extends StaticBody3D
@onready var elctrodoor: Node3D = $".."

func activate():
	elctrodoor.activate()
