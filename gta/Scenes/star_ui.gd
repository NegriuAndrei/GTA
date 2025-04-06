extends CanvasLayer

@onready var star_display = $StarDisplay
@onready var star_sound: AudioStreamPlayer2D = $StarSound

var previous_star_level = -1  # so it's different at start

func _process(delta):
	var new_star_level = get_star_level_from_score(Global.score)
	if new_star_level != previous_star_level:
		update_star_image(new_star_level)
		previous_star_level = new_star_level

func get_star_level_from_score(score):
	if score >= 17:
		return 5
	elif score >= 13:
		return 4
	elif score >= 8:
		return 3
	elif score >= 4:
		return 2
	elif score >= 1:
		return 1
	else:
		return 0

func update_star_image(level):
	match level:
		5:
			star_display.texture = load("res://assets/Animations/5-stars.png")
		4:
			star_display.texture = load("res://assets/Animations/4-stars.png")
		3:
			star_display.texture = load("res://assets/Animations/3-stars.png")
		2:
			star_display.texture = load("res://assets/Animations/2-stars.png")
		1:
			star_display.texture = load("res://assets/Animations/1-star.png")
		_:
			star_display.texture = load("res://assets/Animations/no-stars.png")

	# Only play the sound if it's not the no-stars case
	if level != 0:
		star_sound.play()
