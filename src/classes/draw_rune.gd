extends Resource

class_name DrawRune

var points : Array[Vector3]
var center : Vector3
var bb_min : Vector3 = Vector3(100000000.0 , 100000000.0 , 100000000.0)
var bb_max : Vector3 = Vector3(-100000000.0 , -100000000.0 , -100000000.0)

func compute_bb(point : Vector3):
	
	for axis in range(3):
		if point[axis] < bb_min[axis]:
			bb_min[axis] = point[axis]
		if point[axis] > bb_max[axis]:
			bb_max[axis] = point[axis]
	
func scale_points():
	
	generate_bounding_box()
	

	for i in range(points.size()): 
		for axis in range(3):
			var denom := (bb_max[axis] - bb_min[axis]) 
			if(denom != 0.0):
				points[i][axis] /= denom
	
	bb_center()
	for i in range(points.size()):
		points[i] -= center

	generate_bounding_box()

func add_point(point : Vector3) : 
	points.append(point)
	compute_bb(point)

func generate_bounding_box():
	bb_min = Vector3(100000000.0 , 100000000.0 , 100000000.0)
	bb_max = Vector3(-100000000.0 , -100000000.0 , -100000000.0)
	
	for point in points:
		compute_bb(point)

func bb_center():
	center = (bb_max + bb_min)/2
	return center

func dist_any_rune() -> float:
	var min_avg_dist := 10000000.0
	var current_rune := DrawRune.new()
	print("centre avant : ", bb_center())
	scale_points()
	print("centre : ", bb_center())
	for rune_t in Rune.rune_type:
		var avg_dist := 0.0
		current_rune.points.clear()
		current_rune.points.append_array(Testmaster.rune_ref_points[Rune.rune_type[rune_t]])
		current_rune.bb_center()
		print("centre rune : ", current_rune.bb_center())
		var pointsP : Array[Vector3]
		var pointsM : Array[Vector3]
		
		if current_rune.points.size() > points.size():
			pointsP = current_rune.points
			pointsM = points
		else:
			pointsP = points
			pointsM = current_rune.points
		
		for pp in pointsP:
			var min_dist = 10000000.0
			for pm in pointsM:
				var dist_squared := pp.distance_squared_to(pm)
				if dist_squared < min_dist:
					min_dist = dist_squared
			avg_dist += min_dist
		avg_dist /= pointsP.size()
		if avg_dist < min_avg_dist:
			min_avg_dist = avg_dist
		
	return min_avg_dist
