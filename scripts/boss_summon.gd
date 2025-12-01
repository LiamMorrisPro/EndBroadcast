extends Node3D

@export var boss : Node3D

var moving : bool = false


func _ready():
	boss.summon.connect(_summon)
	pass


func _process(delta: float) -> void:
	if position.y == 0: 
		moving = false
	
	if moving == true:
		position.y = lerpf(position.y, 0, delta * 10)
	pass


func _summon():
	moving = true

	pass
