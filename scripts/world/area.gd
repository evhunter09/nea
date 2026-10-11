extends Area3D

@export var type: Types
@export var action: Action
enum Types {REPEAT, ONCE}
enum Action {TO_COMBAT, TO_MOVING, PICKUP}

@onready var player = Globals.players[0]

signal enter_firstperson
signal enter_thirdperson

func _ready():
	if type == Types.REPEAT: # only combat / moving zones
		enter_firstperson.connect(player.camera_offset.on_entered_firstperson)
		enter_thirdperson.connect(player.camera_offset.on_entered_thirdperson)


func _on_body_entered(body: Node3D) -> void:
	if type == Types.REPEAT:
		if action == Action.TO_COMBAT:
			Globals.world_state = Globals.WorldState.COMBAT
			enter_firstperson.emit()
		elif action == Action.TO_MOVING:
			Globals.world_state = Globals.WorldState.MOVING
			enter_thirdperson.emit()
			
	elif type == Types.ONCE: # animation must contain queue_free() call or else wont be one time use
		if action == Action.PICKUP:
			$AnimationPlayer.play("pickup")
