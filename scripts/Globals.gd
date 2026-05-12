extends Node

@export  var game_state:State = State.IN_GAME
@export  var world_state:WorldState = WorldState.MOVING
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


''' TODO :)
- sprint feedback (camera)
- rotate body + movement + camera
- slide
''' 

''' BUGS 
- cant (not know how) make arcs with not 90 angle
- 

RECORD LATER
- uncrouch under roof - inside it (not get stuck good at least)
- sprint while crouch without key down (toggle) - block
'''

''' TASKS
1) WEAPON SYSTEM
2) EXAMPLE WEAPON (pistol)
3) AREA SYSTEM (is in combat)
4) EXAMPLE MAP WITH PATH'''


''' FUTURE DEV
- path: add current attrib (and id) - allow multiple
- zones: area3d with trigger - next level premade, allow custom effects inc changing / disabling path

TO REMEMBER (warnings)
- dont have curve in 1 axis -> curve in another - leave a straight like if on same axis
'''
