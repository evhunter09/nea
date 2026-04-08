extends CharacterBody3D
@onready var camera_pivot = $pivot
@onready var collision = $CollisionShape3D
@onready var visuals = $MeshInstance3D

@export var DEFAULT_MOVE_SPEED: float = 5.0
@export var SPRINT_MULTI: float = 1.33
@export var JUMP = 45       # velocity at instant when jumping
@export var FRICTION = 3.0  # deceleration when not moving (per frame)
@export var SENSITIVITY = deg_to_rad(5) # rotation per frame (x60 per second)

@export var CROUCH_HEIGHT_MULTI = 0.8
@onready var DEFAULT_HEIGHT = collision.shape.height

@export var state: State
var health: int
var lives: int
var holding = []
var inventory = {}
var movement: Movement
var points: int
var move_speed: float

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
	print(movement)
	print("before: ", move_speed)
	if Globals.world_state == ws.MOVING:
		movement = Movement.WALK
		move_speed = DEFAULT_MOVE_SPEED
	else:
		movement = Movement.RUN
		move_speed = DEFAULT_MOVE_SPEED * SPRINT_MULTI
	print("after ", move_speed)


func _ready() -> void:
	movement = Movement.WALK
	move_speed = DEFAULT_MOVE_SPEED

func _physics_process(_delta):
	if not is_on_floor():  # falling
		velocity += get_gravity()
	elif Input.is_action_just_pressed("player1_jump"): # is on floor
		velocity.y = JUMP
	elif Input.is_action_just_pressed("player1_duck"): # exclusive with jumping and falling
		duck()
	elif Input.is_action_pressed("player1_sprint"):
		run()
	else:
		# resets to default speed ONLY if was sprinting
		if movement == Movement.RUN:
			movement = Movement.WALK
			move_speed = DEFAULT_MOVE_SPEED

	var in_dir := Input.get_vector("player1_move_left", "player1_move_right",
								   "player1_move_for", "player1_move_back")
	var direction := (transform.basis * Vector3(in_dir.x, 0, in_dir.y)) # apply to existing direction

	if direction: # a key is down 
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)  # slowing down
		velocity.z = move_toward(velocity.z, 0, FRICTION)
	
	var turn_dir = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	rotate_y(-turn_dir[0] * SENSITIVITY)
	camera_pivot.rotate_x(turn_dir[1] * SENSITIVITY)
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -0.5*PI, 0.5*PI) # between straight down and up

	move_and_slide()
