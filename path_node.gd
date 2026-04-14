extends Marker3D

@export_range(0, 5, 0.1, "or_greater") var distance = 1.0

func _ready():
	$MeshInstance3D.mesh.Height = distance
