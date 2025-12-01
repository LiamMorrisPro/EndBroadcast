extends Node3D

var key : bool = false
@onready var laser_1: Node3D = $LaserGun19
@onready var laser_2: Node3D = $LaserGun20

@export var target_key_1 : Node3D
@export var target_key_2 : Node3D

@onready var door_blocker: StaticBody3D = $StaticBody3D



func _ready():
	laser_1.active = false
	laser_2.active = false
	laser_1.laser_ref.laser_state = laser_1.laser_ref.laser.on
	laser_2.laser_ref.laser_state = laser_2.laser_ref.laser.on
	
	target_key_1.tree_exited.connect(key_set)
	target_key_2.tree_exited.connect(key_set)

func _process(_delta: float) -> void:
	
	if key == false:
		return
	
	
	if key == true:
		key = false
		laser_1.laser_ref.laser_state = laser_1.laser_ref.laser.off
		laser_2.laser_ref.laser_state = laser_2.laser_ref.laser.off
		door_blocker.queue_free()


var key_val = 0
func key_set():
	key_val += 1
	if key_val >= 2:
		key = true
