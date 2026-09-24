extends Node

const LEVEL_SCENES: Array[PackedScene] = [
	preload("res://Level1.tscn"),
	preload("res://Level2.tscn")
]

@onready var level_container: Node2D = $LevelContainer
@onready var level_label: Label = $UILayer/TopBar/LevelLabel
@onready var message_label: Label = $UILayer/MessageLabel

var current_level_index: int = 0
var current_level: RollerLevel = null
var changing_level: bool = false

func _ready() -> void:
	_load_level(0)

func _process(_delta: float) -> void:
	if current_level != null and Input.is_action_just_pressed("restart") and not changing_level:
		_load_level(current_level_index)

func _load_level(index: int) -> void:
	if index < 0 or index >= LEVEL_SCENES.size():
		return

	changing_level = false
	current_level_index = index

	if current_level != null:
		level_container.remove_child(current_level)
		current_level.queue_free()
		current_level = null

	var instance: Node = LEVEL_SCENES[index].instantiate()
	var level: RollerLevel = instance as RollerLevel

	if level == null:
		push_error("The scene root must use level.gd in scripts")
		instance.queue_free()
		return

	current_level = level
	level_container.add_child(current_level)

	current_level.completed.connect(_on_level_completed)
	current_level.player_died.connect(_on_player_died)

	level_label.text = "MR ROLLER DUDE   -   LEVEL %d / 2   -   %s" % [
		index + 1,
		current_level.level_name
	]

	message_label.text = "LEVEL %d - %s" % [index + 1, current_level.level_name]
	_clear_message_after_delay(index)

func _on_player_died() -> void:
	if changing_level:
		return

	message_label.text = "OUCH! TRY AGAIN"
	_clear_message_after_delay(current_level_index)

func _on_level_completed() -> void:
	if changing_level:
		return

	changing_level = true

	if current_level_index == 0:
		message_label.text = "LEVEL 1 COMPLETE!"
		await get_tree().create_timer(1.0).timeout
		_load_level(1)
	else:
		message_label.text = "YOU WIN!  -  MR ROLLER DUDE!"
		await get_tree().create_timer(1.5).timeout
		_load_level(0)

func _clear_message_after_delay(level_index: int) -> void:
	await get_tree().create_timer(1.0).timeout

	if current_level_index == level_index and not changing_level:
		message_label.text = ""
