class_name DebugDisplay extends MeshInstance3D
var def_offset = Vector3(0, 1.5, 0) # display over objects, instead of in front of all

func update(start: Vector3, end: Vector3, text = null):
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(def_offset)
	mesh.surface_add_vertex((end - start) + def_offset)
	mesh.surface_end()
	
	$Label3D.text = str(text) if text else ""
