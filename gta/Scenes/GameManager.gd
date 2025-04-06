extends Node

@export var game_duration_sec: int = 300  # 360 secunde = 6 minute
@export var player: NodePath              # Calea către nodul jucătorului (ex: "Player")

var timer_label: NodePath = "CanvasLayer5/TimerLabel"  # Calea corectă relativă
var timer := 0.0
var game_ended := false

func _ready():
	set_process(true)

func _process(delta):
	if game_ended:
		return

	timer += delta
	update_timer_label()  # Actualizează timerul vizual

	if timer >= game_duration_sec:
		end_game(true)  # Jucătorul câștigă

	var player_node = get_node_or_null(player)
	if player_node and player_node.hp <= 0:
		end_game(false)  # Jucătorul pierde

func update_timer_label():
	var time_left = int(game_duration_sec - timer)
	if time_left < 0:
		time_left = 0
	var minutes = time_left / 60
	var seconds = time_left % 60
	var formatted = "%02d:%02d" % [minutes, seconds]
	
	var label = get_node_or_null(timer_label)
	if label:
		label.text = formatted
	else:
		print("❌ TimerLabel not found at path: ", timer_label)

func end_game(won: bool):
	game_ended = true
	set_process(false)

	if won:
		get_tree().change_scene_to_file("res://Scenes/win_screen2.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
