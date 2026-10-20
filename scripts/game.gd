extends Node

@onready var world := $world 
@onready var path := $world/path  #cant be used in other node's ready()
@onready var HUD := $HUD

func _ready() -> void:
	# IN GAME: player setup
	# default starts at 0.1 to prevent innaccuracy, making it negative - sets node to -1
	var start_pos = path.get_pos_on_path(0.1) 
	$player.transform = start_pos
	$player._progress = 0.1
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
