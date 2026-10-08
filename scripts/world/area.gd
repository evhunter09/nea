extends Area3D ## default only

@export var type: Types
enum Types {TO_COMBAT, TO_MOVING}

@onready var player = Globals.players[0]

signal enter_firstperson
signal enter_thirdperson

func _ready():
	enter_firstperson.connect(player.camera_offset.on_entered_firstperson)
	enter_thirdperson.connect(player.camera_offset.on_entered_thirdperson)


func _on_body_entered(body: Node3D) -> void:
	if type == Types.TO_COMBAT:
		Globals.world_state = Globals.WorldState.COMBAT
		enter_firstperson.emit()
	else:
		Globals.world_state = Globals.WorldState.MOVING
		enter_thirdperson.emit()
