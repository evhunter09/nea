extends HitscanGun

func _ready():
	super()
	# properties:
	cooldown = 250
	trail_duration = .25
	ammo_type = 1
	max_ammo = 12
	ammo = 5 # starting ammo - when instance is created
	damage = 2
	reload_duration = 950
	equip_time = 800

func reload(user):
	reloading = true
	anim_player.play("reload")
	next_use = Time.get_ticks_msec() + reload_duration
	
	# either how much player has left, or how much more to fill up max_ammo
	var ammo_extra = min(max_ammo - ammo, user.inventory[ammo_type])
	ammo += ammo_extra
	user.inventory[ammo_type] -= ammo_extra
