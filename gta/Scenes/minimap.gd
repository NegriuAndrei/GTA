extends SubViewport

@onready var camera = $MinimapCamera

func _physics_process(_delta):
	# Verifică dacă există un player activ setat în Global
	if Global.active_player:
		# Urmărește poziția obiectului setat ca active_player
		camera.position = Global.active_player.position
