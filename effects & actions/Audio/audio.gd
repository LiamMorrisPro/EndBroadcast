extends Node3D
class_name audio_player


@export var AudioLibrary : Dictionary[String, AudioStream]
@export var volume_adjust : float = -10.0



func start_stream(key : String):
	
	var stream_player = AudioStreamPlayer.new()
	add_child(stream_player)
	stream_player.finished.connect(func(): stream_player.queue_free())
	
	stream_player.bus = "SFX"
	stream_player.stream = AudioLibrary.get(key)
	stream_player.volume_db = volume_adjust
	stream_player.pitch_scale = 1.0 + randf_range(-0.3,0.3)
	
	stream_player.play()





func close_all_streams():
	pass
