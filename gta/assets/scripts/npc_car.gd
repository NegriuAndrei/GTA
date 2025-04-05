extends CharacterBody2D

# Car movement parameters
@export var max_speed: float = 400.0              # Maximum forward speed
@export var acceleration_rate: float = 800.0        # Acceleration force
@export var braking_rate: float = 1000.0            # Braking force
@export var steering_rate: float = 2.0              # How quickly the car can rotate
@export var drift_damping: float = 5.0              # How quickly lateral drift is reduced

# NPC behavior parameters
@export var path_speed: float = 100.0               # Speed at which the target moves along the path
@export var path_follow_node: NodePath            # Reference to the PathFollow2D node guiding the car
var target_follow: PathFollow2D

func _ready():
	if path_follow_node:
		target_follow = get_node(path_follow_node)
	else:
		print("No PathFollow2D node assigned for NPC car.")

func _physics_process(delta: float) -> void:
	if target_follow:
		# Move the target along the path
		target_follow.progress += path_speed * delta
		var target_pos = target_follow.global_position

		# Calculate desired direction toward the target and current forward direction
		var desired_direction = (target_pos - global_position).normalized()
		var current_forward = transform.x
		var angle_diff = current_forward.angle_to(desired_direction)
		
		# Rotate the car, clamping the turn rate to avoid sudden direction changes
		rotation += clamp(angle_diff, -steering_rate * delta, steering_rate * delta)

		# Compute forward speed by projecting velocity onto the car's forward direction
		var forward_speed = velocity.dot(transform.x)
		
		# Optionally reduce target speed on sharper turns:
		var desired_speed = max_speed * (1.0 - abs(angle_diff) / PI)
		
		# Determine acceleration or braking based on current forward speed relative to desired speed
		var accel: float = 0.0
		if forward_speed < desired_speed:
			accel = acceleration_rate
		else:
			accel = -braking_rate

		# Update the forward speed value and clamp it
		forward_speed = clamp(forward_speed + accel * delta, 0, max_speed)
		
		# Remove lateral (sideways) velocity to reduce sliding:
		var right_direction = transform.y
		var lateral_speed = velocity.dot(right_direction)
		velocity -= right_direction * lateral_speed * drift_damping * delta

		# Reconstruct the velocity vector with the new forward speed and remaining lateral component
		velocity = transform.x * forward_speed + right_direction * velocity.dot(right_direction)
		
		# Move the car using the updated velocity (in Godot 4 move_and_slide() takes no arguments)
		move_and_slide()
