extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	await get_tree().create_timer(2.0).timeout
	$Armature/Skeleton3D/PhysicalBoneSimulator3D.physical_bones_start_simulation()
	
	for b in $Armature/Skeleton3D/PhysicalBoneSimulator3D.get_children():
		var pickableL = XRToolsGrabPointHand.new()
		var pickableR = XRToolsGrabPointHand.new()
		pickableL.hand = 0
		pickableR.hand = 1
		
		for p in [pickableL, pickableR]:
			b.add_child(p)
			p.action_pressed.connect(
				func (p, g):
					print("PRIS")
			)
			p.action_released.connect(
				func (p, g):
					print("LACHED")
			)
