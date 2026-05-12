extends Label

var default = text
@onready var player = $"/root/Game/player"

func _process(_delta) -> void:
	text = default + "Player:" + "\n.movement " + str(player.movement) +\
	"\nmove_speed " + str(player.move_speed) + \
	"\n._progress " + str(player._progress) + \
	"\n multi_change " + str(player.TEMP) + \
	"\n._offset " + str(player._offset) + \
	"\noffset_limit " + str(player.offset_limit)
