extends SpringArm3D

signal enter_firstperson
signal enter_thirdperson

@export var firstperson_transform := Transform3D()
var thirdperson_length := spring_length      # edit in (3d) editor
var thirdperson_transform := transform

func on_entered_firstperson():
	spring_length = 0
	transform = firstperson_transform

func on_entered_thirdperson():
	spring_length = thirdperson_length
	transform = thirdperson_transform

func _ready():
	enter_firstperson.emit()
