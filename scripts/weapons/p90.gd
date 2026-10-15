extends HitscanGun

func _ready():
	super()
	# properties:
	cooldown = 150
	trail_duration = 0.15
	ammo_type = 1
	max_ammo = 30
	ammo = 10
	damage = 1
	reload_duration = 1250
	equip_time = 800
