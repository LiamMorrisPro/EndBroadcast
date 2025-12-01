extends Node3D

func _ready():
	for child in get_children():
		child.active = false
		child.laser_ref.laser_state = child.laser_ref.laser.off
	pass

func trigger_trap():
	for child in get_children():
		child.laser_ref.laser_state = child.laser_ref.laser.on
