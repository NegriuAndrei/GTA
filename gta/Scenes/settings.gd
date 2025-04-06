extends Control

@onready var volume_slider = $MarginContainer/VBoxContainer/volume

func _ready() -> void:
	await get_tree().process_frame  # Așteptăm un frame pentru a ne asigura că Musicplayer e inițializat

	if is_instance_valid(Musicplayer):
		var db = Musicplayer.current_volume
		var slider_value = inverse_lerp(-60.0, 0.0, db) * 100.0
		volume_slider.value = slider_value
	else:
		print("⚠️ Musicplayer nu este valid sau nu a fost inițializat corect.")

func _on_volume_value_changed(value):
	var db = lerp(-60.0, 0.0, value / 100.0)
	Musicplayer.set_volume(db)

func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)

func _on_resolution_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))

func _on_back_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
