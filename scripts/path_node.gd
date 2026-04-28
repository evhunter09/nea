@tool
class_name PathNode extends Marker3D

@export_range(0, 5, 0.1, "or_greater") var distance := 1.0
@export_range(0, 5, 0.1) var curve_rad := 0.0
@export var curve_dir := 0
@export_range(-180, 180, 0.01, "radians_as_degrees") var curve_angle := 0.0
@export var cum_distance := 0.0

func _ready():
	$debug.mesh.height = max(curve_rad, 0.25) # sets height to minimum 0.25m
	$debug.mesh.top_radius = distance
	$debug.mesh.bottom_radius = distance
