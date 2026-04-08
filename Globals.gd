extends Node

@export var game_state:State = State.MENU
@export var world_state:WorldState = WorldState.COMBAT
@export var level = null
@export var difficulty:Difficulty
@export var game_modifiers = {}
@export var game_save: int = -1
@export var game_stats = {}
@export var current_screen:Screen
@export var players = []

enum State {MENU, LOADING, IN_GAME, PAUSED, EXITING}
enum WorldState {COMBAT, MOVING}
enum Difficulty {EASY, MEDIUM, HARD, SECRET}
enum Screen {NONE, MAIN}



''' TODO :)
- path
- sprint feedback (camera)
- rotate body + movement + camera
- slide

BUGS TO RECORD LATER
- uncrouch under roof - inside it (not get stuck good at least)
- sprint while crouch without key down (toggle) - block
'''
