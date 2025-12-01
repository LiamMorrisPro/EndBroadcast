extends Control

@export var boss_body : CharacterBody3D

var current_health : float
var max_health : float

@onready var display: ProgressBar = $ProgressBar

func _ready() -> void:
	max_health = boss_body.health
	current_health = max_health
	display.value = current_health
	
	boss_body.got_hit.connect(register_hit)
	


func register_hit():
	current_health -= 5
	if current_health <= 0:
		current_health = 0
	
	display.value = current_health
	pass
