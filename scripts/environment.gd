extends WorldEnvironment

@onready var cloudNoise = environment.sky.sky_material.get_shader_parameter("sky_cover").noise
@export var cloudSpeed = 2.0 # per second
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cloudNoise.offset.z += delta * cloudSpeed
