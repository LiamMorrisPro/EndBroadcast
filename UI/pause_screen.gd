extends Control

@onready var pause: Button = $Pause
@onready var play: Button = $Panel/Play
@onready var settings: Button = $Panel/Settings
@onready var menu: Button = $Panel/Menu
@onready var quit: Button = $Panel/Quit


@onready var settings_panel: Control = $Settings
@onready var settings_close: Button = $Settings/ColorRect/Close
@onready var volume_slider: HSlider = $Settings/ColorRect/Control/HSlider
@onready var sfx_slider: HSlider = $Settings/ColorRect/Control/HSlider2



var paused : bool = false

@onready var panel: Panel = $Panel

func _ready() -> void:
	
	pause.pressed.connect(_pause)
	play.pressed.connect(_play)

	menu.pressed.connect(_menu)
	quit.pressed.connect(_quit)
	
	settings.pressed.connect(self.show_settings.bind(true))
	settings_close.pressed.connect(self.show_settings.bind(false))
	
	volume_slider.value = GameMaster.music_volume_adjust
	sfx_slider.value = GameMaster.sfx_volume_adjust
	
	panel.visible = false
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused == false:
			_pause()
			
		else:
			_play()
	pass



func _pause():
	get_tree().paused = true
	paused = true
	panel.visible = true
	pass

func _play():
	get_tree().paused = false
	paused = false
	panel.visible = false
	show_settings(false)
	pass

func show_settings(toggle : bool):
	if toggle == true:
		settings_panel.visible = true
	else:
		settings_panel.visible = false

func _menu():
	get_tree().paused = false
	GameMaster.main_menu_start()
	pass

func _quit():
	get_tree().quit()
	pass


func _volume_value_changed(value: float) -> void:
	GameMaster.update_music_volume(value)

func _SFX_value_changed(value: float) -> void:
	GameMaster.update_sfx_volume(value)
