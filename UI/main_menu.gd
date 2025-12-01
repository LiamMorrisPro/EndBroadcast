extends Control

@onready var start_button: Button = $MenuButtons/StartButton
@onready var credits_button: Button = $MenuButtons/Credits
@onready var settings_button: Button = $MenuButtons/Settings
@onready var quit_button: Button = $MenuButtons/Quit



@onready var credits_panel: Control = $Credits
@onready var credits_close: Button = $Credits/ColorRect/Close

@onready var settings_panel: Control = $Settings
@onready var settings_close: Button = $Settings/ColorRect/Close

@onready var volume_slider: HSlider = $Settings/ColorRect/Control/HSlider
@onready var sfx_slider: HSlider = $Settings/ColorRect/Control/HSlider2



func _ready():
	settings_close.disabled = true
	credits_close.disabled = true
	
	start_button.pressed.connect(start_game)
	credits_button.pressed.connect(self.show_credits.bind(true))
	credits_close.pressed.connect(self.show_credits.bind(false))
	
	settings_button.pressed.connect(self.show_settings.bind(true))
	settings_close.pressed.connect(self.show_settings.bind(false))
	
	credits_panel.visible = false
	settings_panel.visible = false
	
	quit_button.pressed.connect(quit_game)
	
	volume_slider.value = GameMaster.music_volume_adjust
	sfx_slider.value = GameMaster.sfx_volume_adjust
	
	pass



func start_game():
	GameMaster.level_start(1)
	pass



func show_credits(toggle : bool):
	if toggle == true:
		credits_panel.visible = true
		credits_close.disabled = false
		pass
	else:
		credits_panel.visible = false
		credits_close.disabled = true
	pass

func show_settings(toggle : bool):
	if toggle == true:
		settings_panel.visible = true
		settings_close.disabled = false
		pass
	else:
		settings_panel.visible = false
		settings_close.disabled = true
	pass






func quit_game():
	get_tree().quit()
	pass


func _music_value_changed(value: float) -> void:
	GameMaster.update_music_volume(value)

func _SFX_value_changed(value: float) -> void:
	GameMaster.update_sfx_volume(value)
