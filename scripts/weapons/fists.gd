extends Weapon
@onready var hitArea := $physics/useLocation/hitArea
@onready var leftHandLocation := $physics/leftHandLocation
@onready var useLocation := $physics/useLocation

@export var knockback_speed := 8.0
var last_hit: int ## Milliseconds
var last_arm := 1 ## -1 for left, 1 for right

func _ready():
	type = self.get_script() # replace with melee class when made
	# properties:
	cooldown = 300
	damage = 2
	equip_time = 400


func use(user):
	super(user)
	if Time.get_ticks_msec() < last_hit + 600: # within 600ms of start of last use (but after next_use)
		if last_arm == 1:
			anim_player.play("use_left")
			last_arm = -1 # alternate between left and right
		else: last_arm = 1
	
	if hitArea.has_overlapping_bodies():
		var hit = hitArea.get_overlapping_bodies()
		if user in hit: hit.erase(user)  # filter out the player to not self harm
		if hit:  # if has other bodies inside
			weapon_hit(hit[0], null, user)  # only first - should be the closest one

func get_out(user):
	if user is Player or user is Enemy: # always have holdLocations (hands)
		leftHandLocation.position.x = -2 * user.get_node("holdLocation").position.x # mirrors position around centre
		useLocation.position.x = -user.get_node("holdLocation").position.x # centres, same as hitscanGun
	super(user)

func weapon_hit(object, location, user):
	last_hit = Time.get_ticks_msec()
	if object is Character or object is RigidBody3D:
		Globals.knockback(user, object, knockback_speed)
	if object is Character:
		object.on_hit(damage, user)

func _physics_process(_delta):
	if not anim_player.is_playing():
		anim_player.play("idle") # does NOT resume from same time if interrupted
