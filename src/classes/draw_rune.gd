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
	
func get_2d_mean_pos(points2d: Array[Vector2]) -> Vector2:
	var mean_pos := Vector2.ZERO
	for p in points2d:
		mean_pos += p
	mean_pos /= points2d.size()
	return mean_pos

func get_mean_pos() -> Vector3:
	var mean_pos := Vector3.ZERO
	for p in points:
		mean_pos += p
	mean_pos /= points.size()
	return mean_pos

#norm inf
func get_2d_radius(points2d: Array[Vector2]) -> float:
	var maxv := 0.0
	for p in points2d:
		maxv = max(maxv, max(abs(p.x), abs(p.y)))
	return maxv
## Récup plan orthogonal à la moyenne des normales
func get_plane() -> Plane:
	return Plane(mean_normal, 0)
	
	
	
func get_non_colinear(vec: Vector3):
	if vec.y == 0 && vec.z == 0:
		return Vector3(0, 1, 0);
	else:
		return Vector3(1, 0, 0)

func get_one_Transform(normal: Vector3) -> Basis:
	var mean_pos := get_mean_pos()
	# will not work without player
	
	# up changes nothing but prevents the player from ever drawing "under" this vector. Keeps the winding the same.
	var n_c_vector: Vector3 = Gamemaster.player.global_position - mean_pos
	var b2 := normal.cross(n_c_vector)
	var b3 := normal.cross(b2)
	
	var t := Basis(b2.normalized(), b3.normalized(), normal).inverse()
	return t

func get_projected_points() -> Array[Vector2]:
	var projected_points : Array[Vector2] = []
	var mean := mean_normal.normalized()
	var T := get_one_Transform(mean)
	print("transform : ", T)
	
	for p in points:
		var proj:Vector3 = T * p
		
		projected_points.append(Vector2(proj.x, proj.y))
	
	var center := get_2d_mean_pos(projected_points)
	for i in projected_points.size():
		projected_points[i] = projected_points[i] - center
	
	var radius := get_2d_radius(projected_points)
	print(radius)
	for i in projected_points.size():
		projected_points[i] = projected_points[i] / radius
	
	return projected_points

func get_points_from_2d_points(points_2d : Array[Vector2], recognizer : GestureRecognizer, id : int) -> Array[GestureRecognizer.Point]:
	var res_points : Array[GestureRecognizer.Point]
	for p in points_2d:
		res_points.append(recognizer.Point.new(p.x, p.y, id))
	return res_points
	
func get_2d_coordinates(recognizer : GestureRecognizer, id : int) -> Array[GestureRecognizer.Point]:
	compute_mean_normal()
	var p_2d := get_projected_points()
	Gamemaster.player.get_node("XRCamera3D/drawingPreview").plotPoints(p_2d)
	return get_points_from_2d_points(p_2d, recognizer, id)
