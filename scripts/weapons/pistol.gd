extends HitscanGun

func _ready():
	super()
	# properties:
	cooldown = 250
	trail_duration = 0.25
	ammo_type = 1
	max_ammo = 12
	ammo = 5 # starting ammo - when instance is created
	damage = 2
	reload_duration = 950
	equip_time = 800
