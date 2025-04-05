extends CharacterBody2D

@export var steering_angle = 15
@export var engine_power = 900
@export var friction = -55
@export var drag = -0.06
@export var braking = -450
@export var max_speed_reverse = 250
@export var slip_speed = 400
@export var traction_fast = 2.5
@export var traction_slow = 10

var wheel_base = 65
var acceleration = Vector2.ZERO
var steer_direction = 0.0

signal entered_by_player(car)
@export var is_current_character_active: bool = false
@onready var camera=$Sprite2D/Camera2D

@onready var entry_area = $Area2D
var player_in_area = null  # Referință la player, dacă e în apropiere
var is_in_vehicle = false  # Verifică dacă playerul este în mașină

func _ready():
	#camera.enabled = false
	
	
		
	entry_area.body_entered.connect(_on_entry_area_body_entered)
	entry_area.body_exited.connect(_on_entry_area_body_exited)

func _on_entry_area_body_entered(body):
	if body.is_in_group("PlayerGroup"):
		player_in_area = body  # Salvează referința la player, dar nu face switch încă
		#print("Player entered area: ", player_in_area)

func _on_entry_area_body_exited(body):
	if body == player_in_area and !is_in_vehicle:
		player_in_area = null
		print("am iesit")  # Dacă playerul a ieșit din aria mașinii
		#print("Player exited area")

func _process(delta):
	#if player_in_area:
		#print("Player collision active: ", !player_in_area.get_node("Collision").is_disabled())
	if Input.is_action_just_pressed("Ui_accept") and is_in_vehicle:
		exit_vehicle(player_in_area)

	# Verifică dacă playerul e în apropiere și apasă tasta E
	if player_in_area and Input.is_action_just_pressed("Ui_accept"):
		if not is_in_vehicle:
			enter_vehicle(player_in_area)


var last_velocity = Vector2.ZERO  # Variabilă pentru a salva viteza vehiculului
var last_direction = Vector2.ZERO  # Variabilă pentru a salva direcția vehiculului

func enter_vehicle(player):
	emit_signal("entered_by_player", self)
	camera.enabled = true
	player.deactivate_camera();
	# Dezactivează player-ul în mod sigur (call_deferred)
	player.call_deferred("set", "is_current_character_active", false)
	player.call_deferred("set", "visible", false)
	player.call_deferred("set_physics_process", false)
	var player_collision = player.get_node("Collision")  # Presupun că numele nodului de coliziune este "Collision"
	player_collision.set_deferred("disabled", true)

	# Salvează viteza și direcția vehiculului
	last_velocity = velocity
	last_direction = velocity.normalized()

	# Activează mașina
	call_deferred("set", "is_current_character_active", true)

	# Activează indicatorul pentru că jucătorul este în vehicul
	is_in_vehicle = true

	# O dată ce am făcut switch, ștergem referința
	#player_in_area = null
	print("Player entered vehicle")

func exit_vehicle(player):
	player.position = position + Vector2(0, -20) 
	# Dezactivează mașina
	is_current_character_active = false  # Dezactivează vehiculul
	player.activate_camera();
	camera.enabled = false

	# Activează player-ul în mod sigur
	player.is_current_character_active = true  # Activează playerul
	player.visible = true  # Face playerul vizibil
	player.set_physics_process(true)  # Permite procesarea fizicii pentru player
	var player_collision = player.get_node("Collision")  # Presupun că numele nodului de coliziune este "Collision"
	player_collision.set_deferred("disabled", false)
	# Repoziționează playerul lângă mașină
	# Activează indicatorul pentru că jucătorul a ieșit din vehicul
	is_in_vehicle = false
	player_in_area = null
	




func _physics_process(delta: float) -> void:
	if is_current_character_active:
		#$Camera2D.enabled = true
		acceleration = Vector2.ZERO
		get_input()
		calculate_steering(delta)
		velocity += acceleration * delta
		apply_friction(delta)
	else:
		#$Camera2D.enabled = false
		velocity = last_velocity
		
	
	move_and_slide()

func get_input():
	var turn = Input.get_axis("move_left", "move_right")
	steer_direction = turn * deg_to_rad(steering_angle)

	if Input.is_action_pressed("move_up"):
		acceleration = transform.x * engine_power

	if Input.is_action_pressed("move_down"):
		acceleration = transform.x * braking

func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 10:
		velocity = Vector2.ZERO

	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0

	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta

	var new_heading = rear_wheel.direction_to(front_wheel)

	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast

	var d = new_heading.dot(velocity.normalized())

	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	elif d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	rotation = new_heading.angle()
