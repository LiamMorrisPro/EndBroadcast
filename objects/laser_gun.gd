extends Node3D


@onready var laser_ref: laser_obj = $Laser

@export var t_offset : float = 0.0
@export var t_frequency : float = 2.0
@onready var timer: Timer = $Timer

var active : bool = true


func _ready():
	laser_ref.laser_state = laser_ref.laser.off
	await get_tree().create_timer(t_offset).timeout
	timer.wait_time = t_frequency
	timer.start()


func _on_timer_timeout() -> void:
	if active == true:
		if laser_ref.laser_state == laser_ref.laser.on:
			laser_ref.laser_state = laser_ref.laser.off
		elif laser_ref.laser_state == laser_ref.laser.off:
			laser_ref.laser_state = laser_ref.laser.on
