extends Node3D
class_name Path

@onready var mesh_display = $debug_display

func create_curve(node_list: Array):
	pass

func _ready():
	var node_list = get_children()
	#print(node_list)
	assert(not node_list.is_empty())
	var length = node_list.size()
	var coords = node_list.map(func(n): return n.position)
	
	coords = PackedVector3Array(coords)
	print(coords)
	
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	surface_array[Mesh.ARRAY_VERTEX] = coords
	
	
	mesh_display.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, surface_array)
