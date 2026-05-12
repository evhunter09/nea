extends CharacterBody3D
@onready var camera_pivot = $pivot
@onready var collision = $CollisionShape3D
@onready var visuals = $MeshInstance3D

@onready var path = $"../world/path"

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
var _offset: float   # from path
var _progress: float
var TEMP

var offset_limit

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
	#print(movement)
	#print("before: ", move_speed)
	if Globals.world_state == ws.MOVING:
		movement = Movement.WALK
		move_speed = DEFAULT_MOVE_SPEED
	else:
		movement = Movement.RUN
		move_speed = DEFAULT_MOVE_SPEED * SPRINT_MULTI
	#print("after ", move_speed)


func calc_offset(delta):
	var _dist = (global_basis.inverse() * velocity).x * delta # x axis relative to players rotation
	_offset += _dist

func do_path_movement(inputs, delta):
	var change_mult= path.get_progress_change(_progress, _offset)
	TEMP = change_mult
	_progress += -inputs.y * move_speed * change_mult * delta # forward is minus z
	offset_limit = path.get_allowed_offset(_progress)
	var direction = inputs
	if abs(_offset) > offset_limit:
		var amount = abs(_offset) - offset_limit
		direction.x = clamp(direction.x, -1, 1)
		# FIX - 1) clamp only outwards direction 2) move back inwards if over offset
	return direction


func reset_movement():
	movement = Movement.WALK
	move_speed = DEFAULT_MOVE_SPEED


func _ready() -> void:
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
	
	calc_offset(delta)
	var in_dir = Input.get_vector("player1_move_left", "player1_move_right",
									"player1_move_for", "player1_move_back")
	
	if in_dir: # a key is down 
		in_dir = do_path_movement(in_dir, delta)
		var direction = (transform.basis * Vector3(in_dir.x, 0, in_dir.y)) # apply to existing direction
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)  # slowing down
		velocity.z = move_toward(velocity.z, 0, FRICTION)
	
	var turn_dir = path.get_direction(_progress)
	rotation.y = turn_dir.y
	camera_pivot.rotation.x = clamp(turn_dir.x, -0.5*PI, 0.5*PI) # between straight down and up

	move_and_slide()
