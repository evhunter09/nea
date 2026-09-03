extends TextureRect

@onready var current_player = $"./.." # parent node

func _ready():
	offset_transform_position = -size / 2 # centres texture on position point

func _process(_delta: float) -> void:
	position = current_player.aim_point
