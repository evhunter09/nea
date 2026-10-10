extends SpringArm3D

@export var firstperson_offset := Vector3()
@export var firstperson_rotation := Vector3()
@export var anim_duration := 0.75 ## seconds
var thirdperson_length := spring_length  # edit in (3d) editor
var thirdperson_offset := position
var thirdperson_rotation := rotation

func on_entered_firstperson():
	var anim = create_tween().set_trans(Tween.TRANS_QUAD).set_parallel() # all happen at same time
	anim.tween_property(self, "spring_length", 0, anim_duration)
	anim.tween_property(self, "position", firstperson_offset, anim_duration)
	anim.tween_property(self, "rotation", firstperson_rotation, anim_duration)

func on_entered_thirdperson():
	var anim = create_tween().set_trans(Tween.TRANS_QUAD).set_parallel()
	anim.tween_property(self, "spring_length", thirdperson_length, anim_duration)
	anim.tween_property(self, "position", thirdperson_offset, anim_duration)
	anim.tween_property(self, "rotation", thirdperson_rotation, anim_duration)

func _ready():
	pass
	#enter_firstperson.emit() # to debug in firstperson immediately
