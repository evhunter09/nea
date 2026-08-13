extends Node

@export  var game_state:State = State.IN_GAME
@export  var world_state:WorldState = WorldState.COMBAT
@export var level = null
@export var difficulty:Difficulty
@export_flags("Headshots only", "Weapons limited", "Melee only", "No cover", "Timed")
var game_modifiers := 0
@export var game_save := -1
@export var game_stats := {}
@export var current_screen:Screen
@export var players := []
var curr_enemies: int = 0

enum State {MENU, LOADING, IN_GAME, PAUSED, EXITING}
enum WorldState {COMBAT, MOVING}
enum Difficulty {EASY, MEDIUM, HARD, SECRET}
enum Screen {NONE, MAIN}
enum Modifiers {HEADSHOT_ONLY = 1, # powers of 2 for bitmasks
				LIMIT_WEAPONS = 2,
				MELEE_ONLY    = 4,
				NO_COVER      = 8,
				TIMED         = 16,
}
