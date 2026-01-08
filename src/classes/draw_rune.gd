extends Resource

class_name DrawRune

var points : Array[Vector3]
var normals : Array[Vector3]
var mean_normal : Vector3

func compute_mean_normal() -> Vector3:
	mean_normal = Vector3(0, 0, 0)
	for n in normals:
		mean_normal += n
	mean_normal = mean_normal.normalized()
	return mean_normal
	
## Récup plan orthogonal à la moyenne des normales
func get_plane() -> Plane:
	return Plane(mean_normal)
	
func get_projected_points() -> Array[Vector3]:
	var projected_points : Array[Vector3] = []
	var plane := get_plane()
	for p in points:
		var proj := plane.project(p)
		projected_points.append(proj)
	return projected_points

func to_2d_coordinates(points_3d: Array[Vector3]) -> Array[Vector2]:
	var result: Array[Vector2] = []
	
	# Create two orthonormal basis vectors on the plane
	var normal = mean_normal.normalized()
	
	# Find first basis vector perpendicular to normal
	var basis_x: Vector3
	if abs(normal.x) < 0.9:
		basis_x = (Vector3.RIGHT - normal * normal.dot(Vector3.RIGHT)).normalized()
	else:
		basis_x = (Vector3.UP - normal * normal.dot(Vector3.UP)).normalized()
	
	# Find second basis vector perpendicular to both normal and basis_x
	var basis_y = normal.cross(basis_x).normalized()
	
	# Project each point onto the 2D plane defined by basis_x and basis_y
	for point in points_3d:
		var x = point.dot(basis_x)
		var y = point.dot(basis_y)
		result.append(Vector2(x, y))
	
	return result
	
func get_points_from_2d_points(points_2d : Array[Vector2], recognizer : GestureRecognizer, id : int) -> Array[GestureRecognizer.Point]:
	var res_points : Array[GestureRecognizer.Point]
	for p in points_2d:
		res_points.append(recognizer.Point.new(p.x, p.y, id))
	return res_points
	
func get_2d_coordinates(recognizer : GestureRecognizer, id : int) -> Array[GestureRecognizer.Point]:
	compute_mean_normal()
	var p_3d := get_projected_points()
	var p_2d := to_2d_coordinates(p_3d)
	return get_points_from_2d_points(p_2d, recognizer, id)
