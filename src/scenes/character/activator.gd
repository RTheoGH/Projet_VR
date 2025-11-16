extends Node

# definir ici les signaux des inputs qu'on veut transmettre

signal activate(pressed: bool) #ex:X/A pressed on oculus
signal activate_touched(pressed: bool) #ex : X/A touched on oculus

@onready var physics_hand: Node3D = get_parent()
@onready var function_pickup: Node3D = physics_hand.get_node("FunctionPickup")

func _ready() -> void:
	physics_hand.button_pressed.connect(_on_controller_button_pressed)
	physics_hand.button_released.connect(_on_controller_button_released)
	function_pickup.has_picked_up.connect(_on_function_pickup_has_picked_up)
	function_pickup.has_dropped.connect(_on_function_pickup_has_dropped)

func _on_function_pickup_has_picked_up(picked_up_object: Node3D) -> void:
	if picked_up_object.has_method("activate"):
		activate.connect(picked_up_object.activate)
	if picked_up_object.has_method("activate_touched"):
		activate_touched.connect(picked_up_object.activate_touched)

func _on_function_pickup_has_dropped() -> void:
	if function_pickup.picked_up_object.has_method("activate"):
		activate.disconnect(function_pickup.picked_up_object.activate)
	if function_pickup.picked_up_object.has_method("activate_touched"):
		activate_touched.disconnect(function_pickup.picked_up_object.activate_touched)

# choisir ici quelle input correspond à quoi
func _on_controller_button_pressed(name: String) -> void:
	#print("button pressed : ", name)
	
	if name == "ax_touch":
		activate_touched.emit(true)
	elif name == "ax_button":
		activate.emit(true)

func _on_controller_button_released(name: String) -> void:
	if name == "ax_touch":
		activate_touched.emit(false)
	elif name == "ax_button":
		activate.emit(false)
