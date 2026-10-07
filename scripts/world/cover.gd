class_name Cover extends StaticBody3D

signal cover_entered(cover: Cover)
signal cover_left()
signal edge_entered(cover: Cover, which: int) ## -1 for left, 1 for right
signal edge_left()


func _ready():
	var player = Globals.players[0]
	cover_entered.connect(player.enter_cover)
	cover_left.connect(player.leave_cover)
	edge_entered.connect(player.peak_corner)
	edge_left.connect(player.stop_peak)


func _on_cover_area_body_entered(body: Node3D) -> void:
	cover_entered.emit(self)

func _on_cover_area_body_exited(body: Node3D) -> void:
	cover_left.emit()


func _on_edge_entered(body: Node3D) -> void:
	if $coverArea.overlaps_body(body): # no point setting peek direction if player isnt covering
		print("_on_edge_entered ", rad_to_deg(rotation.y))
		var pos_offset = body.global_position - global_position
		var relative_offset = basis.inverse() * pos_offset
		edge_entered.emit(sign(relative_offset.x))

func _on_edge_exited(body: Node3D) -> void:
	if body.peek_direction != 0: edge_left.emit() # dont emit if wasnt covering -
	# if entered from the side
