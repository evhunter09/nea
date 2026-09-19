class_name Character extends CharacterBody3D

### for weapon users
@export_group("Game state")
@export var state: State
@export var health: int
@export var inventory := {}

var view_direction: Vector3

enum State {ALIVE, DEAD}


func on_hit(damage: int, by: Character):
	if health <= 0:
		die()

func die():
	state = State.DEAD
