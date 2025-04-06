extends Node

@onready var music = $music
var current_volume := -30.0

func _ready():
	if music:
		AudioServer.set_bus_volume_db(0, current_volume)
		if not music.playing:
			music.play()
	else:
		print("⚠️ Nodul 'music' nu a fost găsit!")

func set_volume(db: float) -> void:
	current_volume = db
	AudioServer.set_bus_volume_db(0, current_volume)
