extends SubViewport
 
@onready var camera = $MinimapCamera

 
func _physics_process(_delta):
	camera.position = owner.find_child("Player").position 
