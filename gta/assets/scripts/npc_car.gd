extends CharacterBody2D

# Original car parameters (adjust as needed)
@export var steering_angle = 15
@export var engine_power = 900
@export var friction = -55
@export var drag = -0.06
@export var braking = -450
@export var max_speed_reverse = 250
@export var slip_speed = 400
@export var traction_fast = 2.5
@export var traction_slow = 10

# Additional parameters for NPC behavior
@export var path_speed: float = 100.0        # How fast the target moves along the path
@export var steering_rate: float = 2.0         # How quickly the car adjusts its rotation
@export var max_speed: float = 400.0           # Maximum forward speed

# Reference to the PathFollow2D node (set in the editor)
@export var path_follow_node: NodePath
var target_follow: PathFollow2D

var wheel_base = 65
var acceleration = Vector2.ZERO

func _ready():
	if path_follow_node:
		target_follow = get_node(path_follow_node) as PathFollow2D
	else:
		print("No PathFollow2D node assigned for NPC car.")

func _physics_process(delta: float) -> void:
	if target_follow:
		# Advance the target along the path using the new property
		target_follow.progress += path_speed * delta

		
		# Get the target's position
		var target_pos = target_follow.global_position
		
		# Calculate the desired angle from car to target
		var desired_angle = (target_pos - global_position).angle()
		# Calculate the shortest angle difference (normalized between -PI and PI)
		var angle_diff = wrapf(desired_angle - rotation, -PI, PI)
		
		# Smoothly adjust rotation toward the target direction
		rotation += clamp(angle_diff, -steering_rate * delta, steering_rate * delta)
		
		# Accelerate forward in the direction the car is facing
		acceleration = transform.x * engine_power
		velocity += acceleration * delta
		
		# Apply friction and drag to slow down the car naturally
		apply_friction(delta)
		
		# Cap the maximum forward speed
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
			
		move_and_slide()

func apply_friction(delta):
	# Stop the car if nearly stopped
	if acceleration == Vector2.ZERO and velocity.length() < 10:
		velocity = Vector2.ZERO
	# Apply friction and drag forces
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force
