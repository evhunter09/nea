@tool
class_name Path extends Path3D

@export var node_list: Array

var _distance := 0.0


func calc_curve_properties(i, nodes):
	var n = nodes[i]
	if i != nodes.size()-1 and i != 0: # cant calculate angle for start / end

		var in_dir = nodes[i-1].position.direction_to(n.position)
		var out_dir = n.position.direction_to(nodes[i+1].position)
		var right_vector = in_dir.cross(Vector3.UP) # in global space, vector facing perpendicular to in_dir
		var side = right_vector.dot(out_dir) # if out_dir is same or opposite direction to right
		n.curve_dir = sign(side)
		
		in_dir = Vector2(in_dir.x, in_dir.z) # flatten to 2D (players move directions)
		out_dir = Vector2(out_dir.x, out_dir.z)
		n.curve_angle = abs(in_dir.angle_to(out_dir) * 2) # output is half wanted angle
	
	if i != 0: # first length always 0
		var length
		if nodes[i - 1].curve_rad > 0: # if (prev) node has a curve
			length = nodes[i-1].curve_rad * nodes[i-1].curve_angle
		else:
			length = n.position.distance_to(nodes[i-1].position)
		_distance += length
		n.cum_distance = _distance






func create_path(nodes: Array):
	curve.clear_points() # ensures it is reset between levels, or editing
	for i in nodes.size():
		#print(i)
		var n = nodes[i]
		var out_rad_vector = Vector3(0,0,0)
		var in_rad_vector = Vector3(0,0,0)

		# curve needs a point before to use for initial direction
		if i != 0:
			var dir_vector = nodes[i-1].position.direction_to(n.position)
			out_rad_vector = dir_vector * n.curve_rad  * 4/3*(2**0.5 - 1) # for most precise arc
		
		# for previous node's curve
		if i != nodes.size() - 1: # last index one less than length
			var dir_vector = nodes[i+1].position.direction_to(n.position)
			in_rad_vector = dir_vector * nodes[i-1].curve_rad * 4/3*(2**0.5 - 1)
		
		curve.add_point(n.position, in_rad_vector, out_rad_vector)
		calc_curve_properties(i, nodes)



func _ready():
	node_list = get_children()
	# Marker3D is node class of each path node (instead of PathNode)
	node_list = node_list.filter(func(n): return n.get_class() == "Marker3D")
	assert(not node_list.is_empty(), "Path needs at least 1 pathNode")
	
	create_path(node_list)



func _get_current_node(progress: float):
	for i in node_list.size():
		if node_list[i].cum_distance >= progress:
			return node_list[i]
	return 0


func get_direction(progress: float):
	var corresponding_pos = curve.sample_baked_with_rotation(progress, true)
	var dir = corresponding_pos.basis.get_euler()
	return dir


func get_progress_change(progress: float, offset: float) -> float:
	# returns proportion of default change, to multiply by a constant multiplier
	var node = _get_current_node(progress)
	if node.curve_rad > 0:
		var radius = node.curve_rad * node.curve_dir
		return (radius + offset) / radius
	else:
		return 1 # straight segments are constant everywhere


func get_allowed_offset(progress: float):
	var node = _get_current_node(progress)
	return node.distance # instantly changes distance - not currently interpolate
