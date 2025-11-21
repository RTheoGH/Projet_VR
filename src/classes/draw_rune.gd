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

	for point in points : 
		for axis in range(3):
			point[axis] /= (bb_max[axis] - bb_min[axis]) 
			point -= bb_center()

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
	return (bb_max + bb_min)/2

func dist_runes(rune : Rune) -> float:
	var avg_dist := 0.0
	for draw_p in points:
		
		var min_dist = 10000000.0
		for rune_p in rune.points:
			var dist_squared := draw_p.distance_squared_to(rune_p)
			if dist_squared < min_dist:
				min_dist = dist_squared
		avg_dist += min_dist
	
	return avg_dist / len(points)
