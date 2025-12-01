extends Area3D
class_name damage_area

#@onready var timer: Timer = $Timer
var is_active : bool = false

signal on_hit(body)

func activate(active_time : float):
	is_active = true
	#timer.wait_time = active_time
	#timer.start()
	monitoring = true
	pass


func _on_body_entered(body: Node3D) -> void:
	on_hit.emit(body)

func _on_timer_timeout() -> void:
	is_active = false
	monitoring = false
	pass # Replace with function body.
