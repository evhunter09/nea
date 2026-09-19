@abstract
class_name HitscanGun extends Gun

@onready var ray_start := $useLocation # must be outside of player collision, only uses y and z
@onready var trail_start := $effectLocation

@export var bullet_trail := preload("res://weapons/bullet_trail.tscn")
@export var max_range := 1000.0 # longer distance makes trail end closer to crosshair
@export var trail_colour := Color(1,1,1,.5)
@export var trail_duration: float
@export var reload_duration: int

var hit_result: Dictionary # of current / most recent shot
var direction: Vector3


func fire(user):
	ammo -= 1
	check_collision(user)
	show_trail()
	super(user)

func check_collision(user: Character):
	direction = user.view_direction
	var space_state = get_world_3d().direct_space_state
	var ray = PhysicsRayQueryParameters3D.create(ray_start.global_position,
		ray_start.global_position + direction*max_range, 14, [$physics]) 
		# 14 is combined id of collision layer for enemies solid environment and players (2+4+8)
	
	hit_result = space_state.intersect_ray(ray)
	if hit_result: weapon_hit(hit_result.collider, hit_result.position, user)

func show_trail():
	var trail := bullet_trail.instantiate()
	if hit_result:
		trail.create(trail_start.global_position, hit_result.position, trail_colour, trail_duration)
	else:
		var end_position = ray_start.global_position + direction*max_range
		trail.create(trail_start.global_position, end_position, trail_colour, trail_duration)
	$/root/Game.world.add_child(trail) # adds it to the world - not follow player

func get_out(user):
	if user is Player or user is Enemy:
		ray_start.position.x = -user.get_node("holdLocation").position.x # undoes hold location offset
	super(user)

func weapon_hit(object, location, user):
	print("hit ", object)
	if object is Character:
		object.on_hit(damage, user)
