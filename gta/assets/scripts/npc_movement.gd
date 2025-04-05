extends CharacterBody2D

@export var speed := 40.0
@export var direction_change_interval := 2.0

var direction := Vector2.ZERO
var time_since_change := 0.0

@onready var sprite: AnimatedSprite2D = $sprite2

func _ready():
	randomize()
	_pick_new_direction()

func _process(delta):
	time_since_change += delta
	if time_since_change >= direction_change_interval:
		_pick_new_direction()

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		# Pick a new direction on collision
		_pick_new_direction()

	# Update animation
	if direction != Vector2.ZERO:
		_update_animation(direction)

func _pick_new_direction():
	time_since_change = 0.0
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()

func _update_animation(dir: Vector2):
	var anim_name := ""
	var angle = dir.angle()

	if angle >= -PI/8 and angle < PI/8:
		anim_name = "right"
	elif angle >= PI/8 and angle < 3*PI/8:
		anim_name = "down_right"
	elif angle >= 3*PI/8 and angle < 5*PI/8:
		anim_name = "down"
	elif angle >= 5*PI/8 and angle < 7*PI/8:
		anim_name = "down_left"
	elif angle >= 7*PI/8 or angle < -7*PI/8:
		anim_name = "left"
	elif angle >= -7*PI/8 and angle < -5*PI/8:
		anim_name = "up_left"
	elif angle >= -5*PI/8 and angle < -3*PI/8:
		anim_name = "up"
	elif angle >= -3*PI/8 and angle < -PI/8:
		anim_name = "up_right"

	if not sprite.is_playing() or sprite.animation != anim_name:
		sprite.play(anim_name)
