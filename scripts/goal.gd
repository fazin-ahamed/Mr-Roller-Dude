extends Area2D

signal reached

var active: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if active and body.name == "Player":
		active = false
		reached.emit()

func reset_goal() -> void:
	active = true
