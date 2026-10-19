extends RigidBody3D
@onready var explosion := $explosionRadius

@export var damage := 10
@export var falloff := 1.0 ## damage reduction per unit
@export var push_multi := 4.0 ## Times damage by this for speed of knockback
@export var used_colour: Color
var can_use := true


func explode(shooter):
	for body in explosion.get_overlapping_bodies():
		if body == self: continue # filter the barrel itself
		var given_damage = damage - position.distance_to(body.position) * falloff
		body.on_hit(given_damage, shooter)
		Globals.knockback(self, body, given_damage * push_multi)
	
	explosion.reparent($/root/Game.world)
	explosion.get_node("explosion/AnimationPlayer").play("explode")
	
	can_use = false
	$MeshInstance3D.mesh.material.albedo_color = used_colour
	linear_velocity = Vector3(0,12,0)

func on_hit(damage, by):
	if can_use:
		if by is Enemy: by = Globals.players[0] # replace with nearest one, for multiplayer
		# replaces user with player, to attribute damage to - if manage to get enemy to shoot a barrel
		explode(by) # passes on user, so player can score with explosions caused by them
