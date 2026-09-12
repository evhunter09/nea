extends MeshInstance3D

var fade_dur: float

func create(start, end, colour, duration):
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_set_color(colour)
	mesh.surface_add_vertex(start)
	mesh.surface_add_vertex(end)
	mesh.surface_end()
	$Timer.wait_time = duration
	fade_dur = duration

func _process(_delta):
	material_override.albedo_color.a = $Timer.time_left / fade_dur # fade alpha out

func _on_timer_timeout():
	queue_free()
