extends CharacterBody2D

@export var speed := 50
@onready var sprite := $sprite

#@onready var sprite = $sprite  # Numele nodului de tip Sprite2D
@onready var collision = $Collision  # Numele nodului de tip CollisionShape2D
@onready var camera=$sprite/Camera2D

var is_in_vehicle = false  # Dacă player-ul este în vehicul
var is_current_character_active = true

func _ready():
	visible = true
	set_physics_process(true)

func _physics_process(delta):
	if is_current_character_active:
		var direction := Vector2.ZERO

		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()

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


func deactivate_camera():
	camera.enabled = false

func activate_camera():
	camera.enabled = true
