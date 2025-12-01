extends Control

@onready var health_bar: ProgressBar = $ProgressBar

@onready var ammo_bar: HBoxContainer = $HBoxContainer



func _ready() -> void:
	GameMaster.change_player_health.connect(change_health)
	GameMaster.change_player_ammo.connect(change_ammo)
	set_bar_values()




func set_bar_values():
	health_bar.max_value = GameMaster.player_max_health
	health_bar.value = GameMaster.player_health
	pass

func change_health():
	health_bar.value = GameMaster.player_health
	pass




func change_ammo():
	
	#decrease ammo


	var counter : int = 0
	for ammo in ammo_bar.get_children():
		if counter < GameMaster.player_ammo:
			ammo.visible = true
		else:
			ammo.visible = false
		counter += 1

		
