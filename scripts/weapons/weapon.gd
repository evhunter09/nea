@abstract
class_name Weapon extends Node3D

@onready var anim_player = $AnimationPlayer

var type = null
@export var needs_ammo: bool
@export var cooldown: float # milliseconds

var _next_use := 0.0


func user_input(player: Player):
	if Time.get_ticks_msec() >= _next_use:
		_next_use = Time.get_ticks_msec() + cooldown # allow custom delays eg reload
		use(player)

func use(player: Player):
	anim_player.play("use") # anim for just clicking

@abstract func weapon_hit(object: Node, location: Vector3);
