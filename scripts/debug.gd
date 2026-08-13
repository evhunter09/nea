extends Label

var default = text
@onready var player = $"/root/Game/player"
@onready var path = $/root/Game/world/path

func _physics_process(_delta) -> void:
	text = default +\
	"\n movement "+ str(player.movement) +\
	"\n move_speed "+ str(player.move_speed) +\
	"\n velocity "+ str(player.calc_value_offset(Vector3.AXIS_X, 1)) +\
	" " + str(player.calc_value_offset(Vector3.AXIS_Z, 1)) +\
	"\n real velocity " + str(player.get_real_velocity().length()) +\
	"\n _progress "+ str(player._progress) +\
	"\n change_multi "+ str(player.TEMP) +\
	"\n _offset "+ str(player._offset) +\
	"\n offset_limit "+ str(player.offset_limit) +\
	"\n PATH:" +\
	"\n distance "+ str(path._distance) +\
	"\n node "+ str(path.TEMP)
