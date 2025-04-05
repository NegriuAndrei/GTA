extends Node2D

@onready var player = $"Player"
@onready var cars = get_tree().get_nodes_in_group("Cars")  # Toate mașinile din scenă

var is_current_character_active = true
var is_in_vehicle = false  # Verifică dacă playerul se află în vehicul
var current_car = null  # Vehiculul curent în care se află playerul

func _ready():
	# Setează mașinile vizibile și le conectează semnalul
	for car in cars:
		car.visible = true
		car.get_node("CollisionShape2D").disabled = false
		#car.connect("entered_by_player", Callable(self, "_on_car_entered_by_player"))

#func _process(delta):
	# Verifică dacă playerul se află într-un vehicul și apasă tasta E
	#if is_in_vehicle and Input.is_action_just_pressed("Ui_accept"):
		#exit_vehicle()  # Iese din vehicul

	# Verifică dacă playerul e în apropiere și apasă tasta E pentru a intra într-un vehicul
	#if not is_in_vehicle and Input.is_action_just_pressed("Ui_accept"):
		#for car in cars:
			#if car.get_overlapping_bodies().has(player):
				#enter_vehicle(car)

# Funcția care permite intrarea în vehicul
