extends CharacterBody2D

signal died

# Speed
const SPEED: float = 400.0
const JUMP_VELOCITY: float = -900.0

@onready var sprite: Sprite2D = $Sprite2D

var spawn_position: Vector2 = Vector2.ZERO
var can_move: bool = true

func _ready() -> void:
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		return

	# This for gravity otherwwise u dont fall down
	if not is_on_floor():
		velocity += get_gravity() * delta

	# This for jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: float = Input.get_axis("left", "right")
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		# Almost instant and sharp stop
		velocity.x = move_toward(velocity.x, 0.0, 900.0)

	move_and_slide()

	# Change this to customize how much he rolls
	sprite.rotation += (velocity.x / 25.0) * delta

	if global_position.y > 800.0:
		die()

func set_spawn(new_spawn: Vector2) -> void:
	spawn_position = new_spawn
	global_position = spawn_position
	velocity = Vector2.ZERO

func die() -> void:
	if not can_move:
		return

	can_move = false
	died.emit()
	sprite.modulate = Color(1.0, 0.45, 0.45, 1.0)
	velocity = Vector2.ZERO

	await get_tree().create_timer(0.55).timeout

	global_position = spawn_position
	velocity = Vector2.ZERO
	sprite.rotation = 0.0
	sprite.modulate = Color.WHITE
	can_move = true
