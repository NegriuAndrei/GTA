extends Node2D

@onready var player = $"Player"
@onready var cars = get_tree().get_nodes_in_group("Cars")  # Toate mașinile din scenă

var is_current_character_active = true

func _ready():
	for car in cars:
		car.visible = true
		car.get_node("CollisionShape2D").disabled = false
		car.connect("entered_by_player", Callable(self, "_on_car_entered_by_player"))

func _on_car_entered_by_player(car):
	# Dezactivează playerul (deferred)
	player.get_node("sprite").set_deferred("visible", false)
	player.get_node("Collision").set_deferred("disabled", true)
	player.set_deferred("is_current_character_active", false)

	# Activează mașina (deferred)
	car.set_deferred("visible", true)
	car.get_node("CollisionShape2D").set_deferred("disabled", false)
	car.set_deferred("is_current_character_active", true)

	is_current_character_active = false
