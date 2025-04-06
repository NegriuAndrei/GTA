extends Node

var score := 0

func add_point():
	score += 1
	print("Score: ", score)
# Variabila globală pentru a stoca playerul activ
var active_player = null
