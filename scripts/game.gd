extends Node3D

@onready var path = $world/path

func _ready() -> void:
	# IN GAME: player setup
	var start_pos = path.get_pos_on_path(0)
	$player.transform = start_pos
