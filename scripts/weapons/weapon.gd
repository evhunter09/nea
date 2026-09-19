@abstract
class_name Weapon extends Node3D

@onready var anim_player = $AnimationPlayer

var type = null
@export var needs_ammo: bool
@export var cooldown: int # milliseconds
@export var damage: int # may be modified later (for players mainly)
@export var equip_time: int # milliseconds

var next_use := 0


func user_input(user: Character):
	if Time.get_ticks_msec() >= next_use:
		next_use = Time.get_ticks_msec() + cooldown # allow custom delays eg reload
		use(user)

func use(user: Character):
	anim_player.play("use") # anim for just clicking

func get_out(user: Character):
	next_use = Time.get_ticks_msec() + equip_time
	anim_player.play("equip")

@abstract func weapon_hit(object: Node, location: Vector3, user: Character);
