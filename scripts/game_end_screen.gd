extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var game_over_label: Label = $GameOverLabel

@onready var continue_button: Button = $ContinueButton
@onready var end_button: Button = $EndButton


const button_style = "res://UI/styles/button_style.tres"


@export var level_to_continue : int = 1

func _ready():
	GameMaster.end_game.connect(end_game)
	continue_button.modulate.a = 0.0
	end_button.modulate.a = 0.0
	
	
	continue_button.pressed.connect(restart)
	end_button.pressed.connect(to_menu)
	
	pass
	


var is_ended : bool = false
func end_game():
	if is_ended == false:
		is_ended = true
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		#color background
		tween.tween_property(color_rect, "color:a", 1.0, 0.7)
		#game over text
		tween.tween_property(game_over_label, "theme_override_colors/font_color:a", 1.0, 1.0)
		#buttons
		button_tween()
	else:
		pass


func button_tween():
	await get_tree().create_timer(0.7).timeout
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	tween.tween_property(continue_button, "modulate:a", 1.0, 0.1)
	tween.tween_property(end_button, "modulate:a", 1.0, 0.1)
	
	await get_tree().create_timer(0.1).timeout
	continue_button.disabled = false
	end_button.disabled = false


func restart():
	get_tree().paused = false
	GameMaster.level_start(level_to_continue)

func to_menu():
	get_tree().paused = false
	GameMaster.main_menu_start()
