extends Path3D
class_name Path

@onready var mesh_display = $debug_display

func create_curve(node_list: Array):
	Curve3D
	#curve.set_curve()


func _ready():
	var node_list = get_children()
	#print(node_list)
	assert(not node_list.is_empty())
	var length = node_list.size()
	create_curve(node_list)
	
	var coords = node_list.map(func(n): return n.position)
	

func get_coords(progress, offset: float):
	
	pass
