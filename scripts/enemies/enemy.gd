class_name Enemy extends CharacterBody3D

@onready var player: Player = Globals.players[0]

@export var view_distance := 10 # units
@export var turn_speed := deg_to_rad(2) # degrees per frame


func track_player():
	if player.position.distance_to(position) < view_distance:
		var dir_to_player = position.direction_to(player.position)
		var target_rotation = Basis.looking_at(dir_to_player)
		var angle = target_rotation.get_euler().y
		rotation.y = rotate_toward(rotation.y, angle, turn_speed)

		$view_ray.rotation.x = target_rotation.get_euler().x # aims at head area
		# - same height above bottom of player as height of raycast
		if $view_ray.is_colliding() and $view_ray.get_collider() is Player:
			print("shoot")


func _physics_process(delta: float) -> void:
	if not is_on_floor():  # falling
		velocity += get_gravity() * delta
	
	track_player()
	move_and_slide()

func _ready():
	$view_ray.target_position = Vector3(0, 0, -view_distance)
