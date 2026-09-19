@abstract
class_name Gun extends Weapon

@export var ammo_type = null
@export var max_ammo: int
var ammo: int
@export var reloading := false # exported to be able to edit in animation


func _ready():
	type = Gun

func use(user):
	if not reloading:
		super(user) # default click animation - will be able to play if no ammo
		if ammo > 0:
			fire(user)
		elif user.inventory[ammo_type] > 0:
			reload(user)
	
func fire(user: Character):
	anim_player.play("fire")

@abstract func reload(player: Player);
