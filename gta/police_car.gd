extends CharacterBody2D

@export var chase_speed = 200  # Speed at which the police car chases
@export var turn_speed = 5  # Speed at which the police car turns
@export var detection_radius = 300  # Radius to detect the player

@onready var player = get_node("/root/Map/Player")  # Assuming Player node is in this path

var is_chasing = false

func _ready():
	# Optional: Set initial state
	is_chasing = false

func _physics_process(delta):
	# Check if the police car is close enough to the player to start chasing
	if is_player_in_detection_range():
		is_chasing = true

	# Chase the player
	if is_chasing:
		chase_player(delta)

func is_player_in_detection_range() -> bool:
	# If the distance to the player is less than the detection radius, start chasing
	return position.distance_to(player.position) < detection_radius

func chase_player(delta):
	# Calculate the direction to the player
	var direction = (player.position - position).normalized()

	# Rotate towards the player using lerp_angle for smooth rotation
	rotation = lerp_angle(rotation, direction.angle(), turn_speed * delta)

	# Move towards the player
	velocity = direction * chase_speed
	move_and_slide()
