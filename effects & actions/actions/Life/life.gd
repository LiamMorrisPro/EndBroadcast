extends Node3D
class_name life_component

@export var target_body : Node3D
@export var mesh: Node3D

@export var hp : int = 5

@onready var death_delay: Timer = $death_delay
@onready var particles: GPUParticles3D = $GPUParticles3D

func _take_damage(damage : int):
	hp -= damage
	if hp <= 0:
		_die()


func _die():
	if death_delay.is_stopped():
		death_delay.start()
		particles.emitting = true
		mesh.visible = false
		for child in target_body.get_children():
			if child is CollisionShape3D:
				child.queue_free()


func _on_death_delay_timeout() -> void:
	target_body.queue_free()
