extends Button

@export var click_sound : AudioStream
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer



func _ready() -> void:
	if click_sound != null:
		audio_player.stream = click_sound
	pass


func _on_pressed() -> void:
	if audio_player.stream != null:
		audio_player.play()
	pass # Replace with function body.
