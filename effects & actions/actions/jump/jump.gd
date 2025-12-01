extends Node3D
class_name jump_action


@export var target_body : CharacterBody3D


@onready var jumping_particles: GPUParticles3D = $jump_particles
@onready var jump_audio_player: AudioStreamPlayer3D = $jump_sound

@onready var landing_particles: GPUParticles3D = $landing_particles
@onready var landing_audio_player: AudioStreamPlayer3D = $land_sound



func trigger_jump_effect(angle_offset : float):
	if angle_offset == 1:
		angle_offset = 45
	elif angle_offset == -1:
		angle_offset = -45
	
	jumping_particles.rotation.z = deg_to_rad(angle_offset)
	
	jumping_particles.restart()
	jumping_particles.emitting = true
	
	play_jump_audio()
	pass

func play_jump_audio():
	var pitch_offset = randf_range(1.0, 1.5)
	if pitch_offset == jump_audio_player.pitch_scale:
		pitch_offset += 0.1
	jump_audio_player.pitch_scale = pitch_offset

	jump_audio_player.play()
	pass




func trigger_landing_effect(impact_velocity : float):

	landing_particles.restart()
	landing_particles.emitting = true
	
	play_landing_audio(impact_velocity)
	pass

func play_landing_audio(impact_velocity : float):
	var pitch_offset = randf_range(1.0, 1.5)
	if pitch_offset == landing_audio_player.pitch_scale:
		pitch_offset += 0.1
	
	#modify volume based on impact_velocity
	
	landing_audio_player.pitch_scale = pitch_offset

	landing_audio_player.play()
	pass
