extends Node2D  # Sau, în funcție de structura ta de noduri, poate fi alt tip de nod

@onready var player = $"Player"  # Jucătorul curent
@onready var new_character = $"Car"  # Noul caracter care va apărea
#@onready var camera = $"Camera2D"  # Camera 2D, dacă este cazul

var is_current_character_active = true  # Variabilă pentru a ține minte dacă player-ul curent este activ

func _ready():
	# Inițial, player-ul curent este activ și noul caracter este ascuns
	new_character.visible = false
	new_character.get_node("CollisionShape2D").disabled = true  # Asigură-te că coliziunea este dezactivată

func _process(delta):
	# Verifică apăsarea tastei E pentru a schimba între caractere
	if Input.is_action_just_pressed("Ui_accept"):  # "ui_accept" este tasta E în mod implicit
		switch_character()

# Funcție care se ocupă de schimbarea între caractere
func switch_character():
	if is_current_character_active:
		# Ascunde player-ul curent
		player.get_node("sprite").visible = false
		player.get_node("Collision").disabled = true
		player.is_current_character_active = false  # Dezactivează controlul pentru player-ul curent

		# Arată și activează noul caracter
		new_character.visible = true
		new_character.get_node("CollisionShape2D").disabled = false  # Activează coliziunea pentru noul caracter
		new_character.is_current_character_active = true  # Activează controlul pentru noul caracter
		
		# Poziționează camera pe noul caracter (dacă este cazul)
		#camera.follow_smooth = true
		#camera.position = new_character.position  # Poziționează camera pe noul caracter

		is_current_character_active = false  # Setează caracterul curent ca inactiv
