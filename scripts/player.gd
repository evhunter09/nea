class_name Player extends Character
@onready var camera_pivot := $pivot
@onready var collision := $CollisionShape3D
@onready var visuals := $MeshInstance3D
@onready var camera := $pivot/SpringArm3D/Camera3D
@onready var path := $"../world/path" # constant reference hopefully, cant use global variable yet

@export var DEFAULT_MOVE_SPEED := 5.0
@export var SPRINT_MULTI := 1.4
@export var JUMP := 3.0     ## Velocity at instant when jumping
@export var FRICTION := 3.0 ## Deceleration when not moving (per frame)
@export var SENSITIVITY: float

@export var CROUCH_HEIGHT_MULTI := 0.8
@onready var DEFAULT_HEIGHT = collision.shape.height

@export_group("Game state")
@export var lives: int
@export var holding: Array[Weapon] = []
@export var movement: Movement
var points: int
var move_speed: float
var _offset := 0.0   ## Units from path
var _progress := 0.0 ## Units from path
var TEMP
var offset_limit: float
var aim_point: Vector2 ## Pixels
var current_cover = null
var peek_direction := 0 ## -1 for left, 0 for up (normal), 1 for right
@export var _peek_angle := 0 ## only used for animating, exported to be able to

enum Movement {WALK, RUN, JUMP, DUCK, IN_COVER, PEAK, SLIDE}
var WS = Globals.WorldState



func enter_cover(cover: Cover): ## sent from each cover
	print(cover)
	if Globals.world_state == WS.COMBAT:
		movement = Movement.IN_COVER
		enter_crouch()
		current_cover = cover
		
func leave_cover():
	if Globals.world_state == WS.COMBAT:
		movement = Movement.WALK
		reset_movement()
		current_cover = null

func peak_corner(side: int):
	$AnimationPlayer.play("peek" + str(side))
	peek_direction = side

func stop_peak():
	$AnimationPlayer.play_backwards("peek" + str(peek_direction))
	peek_direction = 0
	
func stick_to_cover(cover: Cover, direction):
	#var dir = cover.basis.z # forward for cover is z (- for cover and player)
	
	# rotates input direction to face cover (still relative to player)
	var dir = Vector3(direction.x, 0, direction.y) # cant do basis transform with vector2
	dir = global_basis.inverse() * cover.basis * dir
	return Vector2(dir.x, dir.z)


func enter_crouch():
	visuals.mesh.height = DEFAULT_HEIGHT * CROUCH_HEIGHT_MULTI
	collision.shape.height = DEFAULT_HEIGHT * CROUCH_HEIGHT_MULTI

func duck():
	print("duck: ", movement)
	match movement:
		Movement.IN_COVER:
			movement = Movement.PEAK
			reset_movement()
		Movement.PEAK:
			movement = Movement.IN_COVER
			enter_crouch()
		Movement.DUCK:
			movement = Movement.WALK
			reset_movement()  # default
		Movement.RUN: # to slide
			print("slide (TODO)")
		_:
			movement = Movement.DUCK
			enter_crouch()

func run():
	if Globals.world_state == WS.MOVING:
		movement = Movement.WALK
		move_speed = DEFAULT_MOVE_SPEED
	else:
		movement = Movement.RUN
		move_speed = DEFAULT_MOVE_SPEED * SPRINT_MULTI


func calc_value_offset(axis, delta):
	return (global_basis.inverse() * get_real_velocity())[axis] * delta # axis relative to players rotation

func do_path_movement(delta):
	_offset += calc_value_offset(Vector3.AXIS_X, delta)
	var change_mult = path.get_progress_change(_progress, _offset)
	TEMP = change_mult
	_progress += -calc_value_offset(Vector3.AXIS_Z, delta) * change_mult # forward is minus z

func limit_path_movement(inputs):
	offset_limit = path.get_allowed_offset(_progress)
	var direction = inputs
	if movement == Movement.IN_COVER or movement == Movement.PEAK:
		direction = stick_to_cover(current_cover, direction)
	
	if abs(_offset) > offset_limit:
		var amount = abs(_offset) - offset_limit
		var side = sign(_offset)
		var left_amount = amount if side == -1 else -1   # default range, as
		var right_amount = -amount if side == 1 else 1   # direction is unit vector
		direction.x = clamp(direction.x, left_amount/move_speed, right_amount/move_speed)
	if _progress <= 0:
		direction.y = min(_progress/move_speed, direction.y) # ensures not backwards (positive)
	return direction


func animate():
	rotation.z = deg_to_rad(_peek_angle)
	camera_pivot.rotation.z = deg_to_rad( - _peek_angle) # undoes rotation to stay level



func reset_movement():
	visuals.mesh.height = DEFAULT_HEIGHT
	collision.shape.height = DEFAULT_HEIGHT
	move_speed = DEFAULT_MOVE_SPEED

func _ready() -> void:
	#camera_pivot.rotation.x = -PI / 2 + deg_to_rad(15) # DEBUG top down view - minusing default 15 rotation
	health = 10
	inventory = {1: 15}
	reset_movement()
	Globals.players.append(self)
	$holdLocation/pistol.get_out(self)
	print("this is game")

func _physics_process(delta):
	if not is_on_floor():  # falling
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("player1_jump"): # is on floor
		velocity.y = JUMP
		#movement = Movement.JUMP
	elif Input.is_action_just_pressed("player1_duck"): # exclusive with jumping and falling
		duck()
	elif Input.is_action_pressed("player1_sprint"):
		run()
	else:
		if movement == Movement.RUN: # resets to default speed ONLY if was sprinting
			movement = Movement.WALK
			reset_movement()
	
	var rel_velocity
	var in_dir = Input.get_vector("player1_move_left", "player1_move_right",
									"player1_move_for", "player1_move_back")
	if in_dir: # a key is down 
		in_dir = limit_path_movement(in_dir)
		rel_velocity = in_dir * move_speed
	else:
		rel_velocity = global_basis.inverse() * get_real_velocity() # get relative velocity
		rel_velocity.x = move_toward(rel_velocity.x, 0, FRICTION)  # slowing down
		rel_velocity.y = move_toward(rel_velocity.z, 0, FRICTION)
	
	var turn_dir = path.get_direction(_progress).y # update after calc relative velocity of last frame
	var next_progress = _progress + -rel_velocity.y * delta * path.get_progress_change(_progress, _offset)
	var next_dir = path.get_direction(next_progress).y
	rotation.y = lerp_angle(turn_dir, next_dir, 0.5) # averages angles - wraps around 0 -> 360
	
	var new_velocity = (transform.basis * Vector3(rel_velocity.x, 0, rel_velocity.y)) # apply to existing direction
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z
	
	move_and_slide()
	
	animate()


func _input(event):
	if event is InputEventMouseMotion:
		aim_point = event.position
	view_direction = camera.project_ray_normal(aim_point)
	if event is InputEventMouseButton: if event.pressed:
		$holdLocation/pistol.user_input(self)


func is_invulnerable(from: Vector3):
	if movement == Movement.IN_COVER and peek_direction == 0: # only can be if fully in cover
		var to_enemy = from - position
		print("Vec3 to enemy: ", to_enemy.normalized())
		print("Cover vec3: ", -current_cover.basis.z)
		return (-current_cover.basis.z.dot(to_enemy) > 0) # cover forward is -z (like player)
	return false

func on_hit(damage, by):
	if by is Enemy:
		if not is_invulnerable(by.position):
			health = max(health - damage, 0)
	super(damage, by)

func die(by):
	super(by)
	print("\nPLAYER DEAD\n")
