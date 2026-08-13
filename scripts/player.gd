class_name Player extends CharacterBody3D
@onready var camera_pivot = $pivot
@onready var collision = $CollisionShape3D
@onready var visuals = $MeshInstance3D
@onready var path = $"../world/path" # constant reference hopefully

@export var DEFAULT_MOVE_SPEED := 5.0
@export var SPRINT_MULTI := 1.4
@export var JUMP = 45      # velocity at instant when jumping
@export var FRICTION := 3.0 # deceleration when not moving (per frame)
@export var SENSITIVITY = deg_to_rad(5) # rotation per frame (x60 per second)

@export var CROUCH_HEIGHT_MULTI := 0.8
@onready var DEFAULT_HEIGHT = collision.shape.height

@export_group("Game state")
@export var state: State
@export var health: int
@export var lives: int
@export var holding := []
@export var inventory := {}
@export var movement: Movement
var points: int
var move_speed: float
var _offset := 0.0     # units from path
var _progress := 0.0
var TEMP
var offset_limit: float

enum State {ALIVE, DEAD}
enum Movement {WALK, RUN, JUMP, DUCK, IN_COVER, PEAK, SLIDE}

var ws = Globals.WorldState


func duck():
	print("duck: ", movement)
	if movement == Movement.DUCK:
		movement = Movement.WALK  # default
		visuals.mesh.height = DEFAULT_HEIGHT
		collision.shape.height = DEFAULT_HEIGHT
	elif movement == Movement.RUN: # to slide
		print("slide (TODO)")
	else:
		movement = Movement.DUCK
		visuals.mesh.height = DEFAULT_HEIGHT * CROUCH_HEIGHT_MULTI
		collision.shape.height = DEFAULT_HEIGHT * CROUCH_HEIGHT_MULTI

func run():
	if Globals.world_state == ws.MOVING:
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
	
	if abs(_offset) > offset_limit:
		var amount = abs(_offset) - offset_limit
		var side = sign(_offset)
		var left_amount = amount if side == -1 else -1   # default range, as
		var right_amount = -amount if side == 1 else 1   # direction is unit vector
		direction.x = clamp(direction.x, left_amount/move_speed, right_amount/move_speed)
	if _progress <= 0:
		direction.y = min(_progress/move_speed, direction.y) # ensures not backwards (positive)
	return direction


func reset_movement():
	movement = Movement.WALK
	move_speed = DEFAULT_MOVE_SPEED

func _ready() -> void:
	camera_pivot.rotation.x = -PI / 2 + deg_to_rad(15) # DEBUG top down view - minusing default 15 rotation
	reset_movement()
	print("this is game")

func _physics_process(delta):
	if not is_on_floor():  # falling
		velocity += get_gravity()
	elif Input.is_action_just_pressed("player1_jump"): # is on floor
		velocity.y = JUMP
	elif Input.is_action_just_pressed("player1_duck"): # exclusive with jumping and falling
		duck()
	elif Input.is_action_pressed("player1_sprint"):
		run()
	else:
		if movement == Movement.RUN: # resets to default speed ONLY if was sprinting
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
	do_path_movement(delta) # from current frame, after physics applied
	#if velocity: print(rad_to_deg(path.get_direction(_progress).y - next_dir)) # any error
