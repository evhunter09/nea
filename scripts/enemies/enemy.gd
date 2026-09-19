class_name Enemy extends Character

@onready var player: Player = Globals.players[0]
@onready var weapon: Weapon = $holdLocation/weapon

@export var view_distance := 10 # units
@export var turn_speed := deg_to_rad(2) # degrees per frame
@export var accuracy := 0.02


func randomise_direction():
	view_direction = (view_direction + Vector3(randf_range(-accuracy, accuracy),
							randf_range(-accuracy, accuracy),
							randf_range(-accuracy, accuracy))).normalized()

func track_player():
	if player.position.distance_to(position) < view_distance:
		var dir_to_player = position.direction_to(player.position)
		view_direction = dir_to_player
		var target_rotation = Basis.looking_at(dir_to_player)
		var angle = target_rotation.get_euler().y
		rotation.y = rotate_toward(rotation.y, angle, turn_speed)

		$view_ray.rotation.x = target_rotation.get_euler().x # aims at head area
		# - same height above bottom of player as height of raycast

func try_shoot():
	if Time.get_ticks_msec() > weapon.next_use:
				randomise_direction()
				weapon.user_input(self)


func _physics_process(delta: float) -> void:
	if not is_on_floor():  # falling
		velocity += get_gravity() * delta
	move_and_slide()
	
	if state == State.ALIVE:
		track_player()
		if $view_ray.is_colliding() and $view_ray.get_collider() is Player:
			try_shoot()


func _ready():
	$view_ray.target_position = Vector3(0, 0, -view_distance)
	health = 5
	inventory = {1: 15}
	weapon.get_out(self)


func on_hit(damage, by):
	if by is Player:
		health = max(health - damage, 0)
	super(damage, by)
	
func die():
	$AnimationPlayer.play("die")
	super()
