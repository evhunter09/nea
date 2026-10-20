@abstract
class_name Weapon extends Node3D

@onready var anim_player = $AnimationPlayer

var type = null
@export var needs_ammo: bool
@export var cooldown: int ## Milliseconds
@export var damage: int ## May be modified later in calculations (for players mainly)
@export var equip_time: int ## Milliseconds
@export var replace: Script ## Class of weapon this replaces
@export var effect_property: NodePath ## Property of player / character class
@export var effect_value: Variant ## Has to be same type as original variable
var _prev_value: Variant

var next_use := 0


func user_input(user: Character):
	if Time.get_ticks_msec() >= next_use:
		next_use = Time.get_ticks_msec() + cooldown # allow custom delays eg reload
		use(user)

func use(user: Character):
	anim_player.play("use") # anim for just clicking

func get_out(user: Character):
	transform = Transform3D.IDENTITY # removes previous translation from when in world
	next_use = Time.get_ticks_msec() + equip_time
	anim_player.play("equip")
	$physics.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED) # stops it from falling while in use
	$pickupArea.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED) # prevents detecting players while out
	if user is Player: give_effect(user) # for passive effects, only active while holding

@abstract func weapon_hit(object: Node, location: Vector3, user: Character);

func pick_up(player: Player):
	if not Globals.contains_type(player.holding, get_script()): # prevent replacing with same type of weapon
		if replace and Globals.contains_type(player.holding, replace):
			var location = player.holding.find_custom(func(i): return i.get_script() == replace)
			if location == player.weapon_slot:
				player.holding[location].put_away(player) # or else will stay held but unusable
				call_deferred("reparent", player.hold, false) # prevent godot complaining
				get_out(player)
			else:
				remove_from_world()
			player.holding[location] = self
		
		else:
			player.holding.append(self)
			remove_from_world()

func put_away(user):
	anim_player.play("put away") # must have remove_from_world() method at end
	remove_effect(user)

func enter_world():
	reparent($/root/Game.world) # should stay at same position
	#anim_player.stop() # TEST - could play fall animation?
	$physics.process_mode = Node.PROCESS_MODE_INHERIT
	$pickupArea.process_mode = Node.PROCESS_MODE_INHERIT

func remove_from_world():
	get_parent().call_deferred("remove_child", self) # prevents godot complaining

func give_effect(user: Character): ## Could extend this to add animation / visual effects
	if effect_property:
		_prev_value = user.get_indexed(effect_property)
		user.set_indexed(effect_property, effect_value)
		
func remove_effect(user: Character):
	if effect_property:
		user.set_indexed(effect_property, _prev_value)
