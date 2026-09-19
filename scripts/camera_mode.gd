extends SpringArm3D

signal enter_firstperson
signal enter_thirdperson

@export var firstperson_offset := Vector3()
@export var firstperson_rotation := Vector3()
var thirdperson_length := spring_length      # edit in (3d) editor
var thirdperson_transform := transform

func on_entered_firstperson():
	spring_length = 0
	position = firstperson_offset
	rotation = firstperson_rotation

func on_entered_thirdperson():
	spring_length = thirdperson_length
	transform = thirdperson_transform

func _ready():
	enter_firstperson.emit()
