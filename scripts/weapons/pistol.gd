extends HitscanGun

func _ready():
	super()
	# properties:
	cooldown = 200
	trail_duration = .25
	ammo_type = 1
	max_ammo = 12
	ammo = 5 # starting ammo - when instance is created


func reload(player):
	reloading = true
	anim_player.play("reload")
	_next_use = Time.get_ticks_msec() + reload_duration
	
	# either how much player has left, or how much more to fill up max_ammo
	var ammo_extra = min(max_ammo - ammo, player.inventory[ammo_type])
	ammo += ammo_extra
	player.inventory[ammo_type] -= ammo_extra

func weapon_hit(object, position):
	print("hit ", object)
