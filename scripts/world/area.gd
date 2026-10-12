extends Area3D

@export var type: Types
@export var action: Action
@export var value: int # if applicable to type
@export var active := true
enum Types {REPEAT, ONCE, COOLDOWN}
enum Action {TO_COMBAT, TO_MOVING, PICKUP}

@onready var player = Globals.players[0]

signal enter_firstperson
signal enter_thirdperson

func _ready():
	if type == Types.REPEAT: # only combat / moving zones
		enter_firstperson.connect(player.camera_offset.on_entered_firstperson) # (will) run for all players
		enter_thirdperson.connect(player.camera_offset.on_entered_thirdperson)


func _on_body_entered(body: Node3D) -> void:
	if active:
		if type == Types.REPEAT:
			if action == Action.TO_COMBAT:
				Globals.world_state = Globals.WorldState.COMBAT
				enter_firstperson.emit()
			elif action == Action.TO_MOVING:
				Globals.world_state = Globals.WorldState.MOVING
				enter_thirdperson.emit()
		
		# for once type: animation must contain queue_free() call or else nodes will remain
		elif type in [Types.ONCE, Types.COOLDOWN]:
			active = false
			if type == Types.COOLDOWN:
				$Timer.start()
			
			if action == Action.PICKUP:
				$AnimationPlayer.play("pickup")
				body.pickup(value)


func _on_timer_timeout() -> void:
	active = true
	$AnimationPlayer.play("appear")
	$AnimationPlayer.queue("idle")
