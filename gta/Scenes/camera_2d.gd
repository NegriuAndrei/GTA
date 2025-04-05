extends Camera2D

@export var player : Node2D
@export var vehicle : Node2D
@export var follow_player = true  # Inițial, camera va urmări playerul

# Folosește această funcție pentru a schimba ținta camerei
func set_target_to_player():
	follow_player = true
	target = player  # Schimbă ținta camerei la player

func set_target_to_vehicle():
	follow_player = false
	target = vehicle  # Schimbă ținta camerei la vehicul

var target : Node2D

# Funcția care actualizează camera
func _ready():
	if follow_player:
		target = player  # Setează playerul ca ținta implicită
	else:
		target = vehicle  # Setează vehiculul ca ținta implicită

# Funcția care urmărește ținta
func _process(delta):
	if target:
		position = lerp(position, target.position, 0.1)  # Urmărește ținta cu o tranziție lină
