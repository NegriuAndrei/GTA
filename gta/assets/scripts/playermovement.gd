extends CharacterBody2D

@export var movement_speed : float = 75
var character_direction : Vector2

@onready var sprite = $sprite  # Numele nodului de tip Sprite2D
@onready var collision = $Collision  # Numele nodului de tip CollisionShape2D

var is_current_character_active = true  # Acesta va fi controlat din scriptul de pe Map

func _physics_process(delta):
	if is_current_character_active:
		# Mișcarea player-ului
		character_direction.x = Input.get_axis("move_left", "move_right")
		character_direction.y = Input.get_axis("move_up", "move_down")
		character_direction = character_direction.normalized()

		if character_direction:
			velocity = character_direction * movement_speed
		else:
			velocity = velocity.move_toward(Vector2.ZERO, movement_speed)

		move_and_slide()
