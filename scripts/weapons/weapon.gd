@abstract
class_name Weapon extends Node3D

@onready var anim_player = $AnimationPlayer

var type = null
@export var needs_ammo: bool
@export var cooldown: int ## Milliseconds
@export var damage: int ## May be modified later in calculations (for players mainly)
@export var equip_time: int ## Milliseconds
@export var replace: Script ## Class of weapon this replaces

var next_use := 0


func user_input(user: Character):
	if Time.get_ticks_msec() >= next_use:
		next_use = Time.get_ticks_msec() + cooldown # allow custom delays eg reload
		use(user)

func use(user: Character):
	anim_player.play("use") # anim for just clicking

func get_out(user: Character):
	position = Vector3.ZERO # removes previous position from when in world
	next_use = Time.get_ticks_msec() + equip_time
	anim_player.play("equip")
	$physics.process_mode = Node.PROCESS_MODE_DISABLED # stops it from falling while in use
	$pickupArea.process_mode = Node.PROCESS_MODE_DISABLED # prevents detecting players while out

@abstract func weapon_hit(object: Node, location: Vector3, user: Character);

func pick_up(player: Player):
	if not Globals.contains_type(player.holding, get_script()): # cant replace with same type of weapon
		if replace and Globals.contains_type(player.holding, replace):
			var location = player.holding.find_custom(func(i): i.get_script() == replace)
			player.holding[location] = self
		else:
			player.holding.append(self)
		remove_from_world()

func put_away():
	anim_player.play("put away") # must have get_parent().remove_child method at end

func enter_world():
	reparent($/root/Game.world) # should stay at same position
	#anim_player.stop() # TEST - could play fall animation?
	$physics.process_mode = Node.PROCESS_MODE_INHERIT
	$pickupArea.process_mode = Node.PROCESS_MODE_INHERIT

func remove_from_world():
	get_parent().call_deferred("remove_child", self) # prevents godot complaining
