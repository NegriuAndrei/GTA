extends CharacterBody2D

@export var speed := 200
@onready var sprite := $sprite

func _physics_process(_delta):
	var direction := Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

func _ready():
	visible = true
	set_physics_process(true)


func _physics_process(delta):
	if is_current_character_active:
		# Mișcarea player-ului
		character_direction.x = Input.get_axis("move_left", "move_right")
		character_direction.y = Input.get_axis("move_up", "move_down")
		character_direction = character_direction.normalized()

	if direction != Vector2.ZERO:
		# Detectăm direcția exactă
		if direction.x > 0 and direction.y < 0:
			sprite.animation = "up_right"
		elif direction.x < 0 and direction.y < 0:
			sprite.animation = "up_left"
		elif direction.x > 0 and direction.y > 0:
			sprite.animation = "down_right"
		elif direction.x < 0 and direction.y > 0:
			sprite.animation = "down_left"
		elif direction.x > 0:
			sprite.animation = "right"
		elif direction.x < 0:
			sprite.animation = "left"
		elif direction.y > 0:
			sprite.animation = "down"
		elif direction.y < 0:
			sprite.animation = "up"
		
		sprite.play()
	else:
		sprite.stop()
