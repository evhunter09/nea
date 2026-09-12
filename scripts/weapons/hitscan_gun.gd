@abstract
class_name HitscanGun extends Gun

@onready var ray_start = $useLocation # must be outside of player collision
@onready var trail_start = $effectLocation

@export var bullet_trail = preload("res://weapons/bullet_trail.tscn")
@export var max_range := 1000.0 # longer distance makes trail end closer to crosshair
@export var trail_colour := Color(1,1,1,.5)
@export var trail_duration: float
@export var reload_duration: float

var hit_result: Dictionary # of current / most recent shot
var direction: Vector3


func fire(player):
	ammo -= 1
	check_collision(player)
	show_trail()
	super(player)

func check_collision(player: Player):
	direction = player.camera.project_ray_normal(player.aim_point)
	
	var space_state = get_world_3d().direct_space_state
	var ray = PhysicsRayQueryParameters3D.create(ray_start.global_position,
		ray_start.global_position + direction*max_range, 6, [$physics]) 
		# 6 is combined id of collision layer for enemies and solid envionment (2 + 4)
	
	hit_result = space_state.intersect_ray(ray)
	if hit_result: weapon_hit(hit_result.collider, hit_result.position)

func show_trail():
	var trail = bullet_trail.instantiate()
	if hit_result:
		trail.create(trail_start.global_position, hit_result.position, trail_colour, trail_duration)
	else:
		var end_position = ray_start.global_position + direction*max_range
		trail.create(trail_start.global_position, end_position, trail_colour, trail_duration)
	$/root/Game.world.add_child(trail) # adds it to the world - not follow player
