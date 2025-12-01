extends Control

@onready var big_boss: CharacterBody3D = $"../../Big_Boss"

@onready var button: Button = $Panel/Button


func _ready():
	visible = false
	big_boss.die.connect(game_end)
	button.pressed.connect(to_menu)
	pass


func game_end():
	get_tree().paused = true
	visible = true
	
	pass

func to_menu():
	call_deferred("to")
	pass

func to():
	get_tree().paused = false
	GameMaster.main_menu_start()
	pass
