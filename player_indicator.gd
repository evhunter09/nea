extends MeshInstance3D

@onready var game = $"../.."
@onready var player = game.find_child("player", true)
@onready var path = $/root/Game/world/path

func _physics_process(_delta: float) -> void:
	var progress = player._progress
	var offset = player._offset
	var pos = path.get_pos_on_path(progress)
	position = pos.origin + pos.basis.x * offset
	basis = pos.basis
