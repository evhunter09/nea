@tool
class_name PathNode extends Marker3D

@export_range(0, 5, 0.1, "or_greater") var distance := 1.0
@export_range(0, 5, 0.1) var curve_rad := 0.0
# read only in editor
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY) var curve_dir := 0
@export_range(-180, 180, 0.01, "radians_as_degrees") var curve_angle := 0.0 ## To next node
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY) var cum_distance := 0.0 

@export var highlighted := false
var def_colour : Color

func _ready():
	$debug.mesh.height = max(curve_rad / 2, 0.2) # keeps height reasonable (and minimum 0.2m)
	$debug.position.y = $debug.mesh.height / 2 # keeps bottom of mesh at origin - can snap to floor
	$debug.mesh.top_radius = max(distance, 0.1)
	$debug.mesh.bottom_radius = max(distance, 0.1)
	def_colour = $debug.mesh.material.albedo_color


func _process(_delta):
	if highlighted:
		$debug.mesh.material.albedo_color = Color(0, 1.0, 0.13, 0.33)
	else:
		if not Engine.is_editor_hint():$debug.mesh.material.albedo_color = def_colour
