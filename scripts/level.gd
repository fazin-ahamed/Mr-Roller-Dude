extends Node2D
class_name RollerLevel

signal completed
signal player_died

@export var level_name: String = "Level"

@onready var player: CharacterBody2D = $Player
@onready var goal: Area2D = $Goal

func _ready() -> void:
	goal.connect("reached", Callable(self, "_on_goal_reached"))
	player.connect("died", Callable(self, "_on_player_died"))

func _on_goal_reached() -> void:
	player.set("can_move", false)
	completed.emit()

func _on_player_died() -> void:
	player_died.emit()
