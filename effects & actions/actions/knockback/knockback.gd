extends Node3D
class_name knockback_action


@export var target_body : CharacterBody3D


func _trigger(direction : Vector3, force : float):
	
	target_body.velocity += direction * force
	pass
