extends Area3D





func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		call_deferred("level_call")

func level_call():
	GameMaster.level_start(2)
	pass
