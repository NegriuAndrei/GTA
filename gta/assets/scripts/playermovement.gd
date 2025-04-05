extends CharacterBody2D

@export var movement_speed : float = 75
var character_direction : Vector2

@onready var sprite = $sprite  # Numele nodului de tip Sprite2D
@onready var collision = $Collision  # Numele nodului de tip CollisionShape2D
@onready var camera=$sprite/Camera2D

var is_current_character_active = true  # Acesta va fi controlat din scriptul de pe Map

var is_in_vehicle = false  # Dacă player-ul este în vehicul

func _ready():
	visible = true
	set_physics_process(true)

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
		#print(is_in_vehicle)
		# Verifică dacă player-ul este în vehicul și dacă se apasă tasta E pentru a ieși
		if is_in_vehicle and Input.is_action_just_pressed("Ui_accept"):  # "ui_accept" este tasta E
			exit_vehicle()

func enter_vehicle(car):
	# Dacă player-ul intră în vehicul, schimbăm starea
	is_in_vehicle = true
	# Dezactivează controlul asupra player-ului
	is_current_character_active = false
	$sprite.visible = false
	$Collision.disabled = true

	# Activează vehiculul
	car.is_current_character_active = true
	car.visible = true
	car.get_node("CollisionShape2D").disabled = false
	emit_signal("entered_by_player", car)

	print("Player has entered the vehicle.")

func deactivate_camera():
	camera.enabled = false

func activate_camera():
	camera.enabled = true

func exit_vehicle():
	print("e bine")
	# Dacă player-ul iese din vehicul, schimbăm starea înapoi la player
	is_in_vehicle = false
	is_current_character_active = true
	$sprite.visible = true
	$Collision.disabled = false

	# Repoziționează player-ul lângă vehicul, ajustați poziția după necesitate
	position = get_parent().position + Vector2(50, 0)  # Ajustează poziția de ieșire

	# Poți să adaugi animație sau orice altceva pentru a face ieșirea mai interesantă

	print("Player has exited the vehicle.")
