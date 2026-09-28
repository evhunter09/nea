class_name Cover extends StaticBody3D

signal cover_entered(cover: Cover)
signal cover_left()


func _ready():
	var player = Globals.players[0]
	cover_entered.connect(player.enter_cover)
	cover_left.connect(player.leave_cover)

func _on_cover_area_body_entered(body: Node3D) -> void:
	cover_entered.emit(self)

func _on_cover_area_body_exited(body: Node3D) -> void:
	cover_left.emit()
