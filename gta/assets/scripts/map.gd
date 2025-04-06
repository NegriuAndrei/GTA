extends Node2D

@onready var cars = get_tree().get_nodes_in_group("Cars")  # Toate mașinile din scenă
#var active_player = null

var is_current_character_active = true
var is_in_vehicle = false  # Verifică dacă playerul se află în vehicul
var current_car = null  # Vehiculul curent în care se află playerul

func _ready():
	# Setează mașinile vizibile și le conectează semnalul
	for car in cars:
		car.visible = true
		car.get_node("CollisionShape2D").disabled = false

# Funcția care setează caracterul activ
#func set_active_player(player_instance):
	#active_player = player_instance
	#print("Playerul activ este acum: ", active_player.name)
