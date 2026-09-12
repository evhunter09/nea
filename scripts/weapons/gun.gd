@abstract
class_name Gun extends Weapon

@export var ammo_type = null
@export var max_ammo: int
var ammo: int
@export var reloading := false # exported to be able to edit in animation


func _ready():
	type = Gun

func use(player):
	if not reloading:
		super(player) # default click animation - will be able to play if no ammo
		if ammo > 0:
			fire(player)
		elif player.inventory[ammo_type] > 0:
			reload(player)
	
func fire(player: Player):
	anim_player.play("fire")

@abstract func reload(player: Player);
