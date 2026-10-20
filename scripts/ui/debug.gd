extends Label

var default = text
@onready var player = Globals.players[0]
@onready var path = $/root/Game.path

@export var enabled := false

func _physics_process(_delta) -> void:
	if enabled:
		text = default +\
		"\n movement "+ Player.Movement.keys()[player.movement] +\
		"\n move_speed "+ str(player.move_speed) +\
		"\n inputted vel "+ str(player.global_basis.inverse() * player.velocity) +\
		"\n velocity "+ str(player.calc_value_offset(Vector3.AXIS_X, 1)) +\
		" " + str(player.calc_value_offset(Vector3.AXIS_Z, 1)) +\
		"\n speed " + str(player.get_real_velocity().length()) +\
		"\n health "+ str(player.health) +\
		"\n weapon "+ str(player.weapon_slot) +" "+ str(player.holding[player.weapon_slot]) +\
	#	"\n _progress "+ str(player._progress) +\
	#	"\n _offset "+ str(player._offset) +\
	#	"\n offset_limit "+ str(path.get_allowed_offset(player._progress)) +\
	#	"\n PATH:" +\
	#	"\n distance "+ str(path._distance) +\
	#	"\n node "+ str(path.TEMP)
		"\n World:" +\
		"\n world_state "+ Globals.WorldState.keys()[Globals.world_state]
