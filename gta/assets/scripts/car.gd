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
var steer_direction

@export var is_current_character_active: bool = false  # <- Asta controlează dacă personajul e controlat

func _physics_process(delta: float) -> void:
	if is_current_character_active:
		$Camera2D.enabled = true
		acceleration = Vector2.ZERO
		get_input()
		calculate_steering(delta)
	else:
		$Camera2D.enabled = false

	velocity += acceleration * delta
	move_and_slide()
	apply_friction(delta)

func get_input():
	var turn = Input.get_axis("move_left", "move_right")
	steer_direction = turn * deg_to_rad(steering_angle)

	if Input.is_action_pressed("move_up"):
		acceleration = transform.x * engine_power

	if Input.is_action_pressed("move_down"):
		acceleration = transform.x * braking

func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
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
