extends Node3D
class_name damage_flash

const FLASH_MATERIAL = preload("uid://dj8a1sff1gkpn")
@onready var timer: Timer = $Timer

@export var mesh_parent : Node
var mesh_array : Array

func _ready() -> void:
	if mesh_parent != null:
		for child in mesh_parent.get_children():
			if child.is_class("MeshInstance3D"):
				mesh_array.append(child)



func _trigger():
	if mesh_parent != null:
		for mesh in mesh_array:
			mesh.material_override = FLASH_MATERIAL
		timer.start()



func _on_timer_timeout() -> void:
	for mesh in mesh_array:
		mesh.material_override = null
	
