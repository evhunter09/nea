extends Control

@onready var player: Player = Globals.players[0]
@onready var scoreNum = $ScoreContainer/ScoreNum


func points_changed(points: int):
	scoreNum.text = str(points)
