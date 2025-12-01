extends Node3D
class_name Bot_Net


signal call_help


var player_position_known : bool = false
var current_target_position : Vector3

var bot_array : Array[Node3D]

func _ready():
	for child in get_children():
		bot_array.append(child)
	pass


func _process(_delta : float) -> void:
	update_visibility()

	pass

func update_visibility():
	for bot in bot_array:
		if bot == null: #for any instance of a bot that has died
			continue
		if bot.canSeeTarget:
			player_position_known = true
			current_target_position = bot.target_position
			return
	
	#if none can see
	player_position_known = false


func _call_help():
	call_help.emit()
