extends Node3D

@export var target_rotation_object : Node3D

func _process(_delta: float) -> void:
	rotation.y = target_rotation_object.rotation.y
