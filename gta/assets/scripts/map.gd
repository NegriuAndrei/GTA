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
	# Dezactivează playerul
	player.get_node("sprite").visible = true
	player.get_node("Collision").disabled = true
	player.is_current_character_active = false

	# Activează mașina
	car.visible = true
	car.get_node("CollisionShape2D").disabled = false
	car.is_current_character_active = true

	is_current_character_active = false
