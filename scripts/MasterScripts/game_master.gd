extends Node
class_name Game_Master

signal change_player_ammo
signal change_player_health
signal player_got_hit
signal end_game

var player_health : int = 15
var player_max_health : int = 15

var player_ammo_max : int = 5
var player_ammo : int = 5

var current_level : int = 0


var music_volume_adjust : float = 0.5
var sfx_volume_adjust: float = 1.0
var music = AudioServer.get_bus_index("Music")
var sfx = AudioServer.get_bus_index("SFX")



const MAIN_MENU = "res://UI/main_menu.tscn"
const level_1_path = "res://areas/room_1.tscn"
const level_2_path = "res://areas/room_2.tscn"

var display_tutorial : bool = false


func update_player_health(change : int):
	player_health = player_health + change
	if player_health > player_max_health:
		player_health = player_max_health
	
	if player_health <= 0:
		game_over()
	
	change_player_health.emit()
	if change < 0:
		player_got_hit.emit()
	pass


func main_menu_start():
	get_tree().change_scene_to_file(MAIN_MENU)

func level_start(level_id : int):
	
	if player_health <= 0:
		player_health = player_max_health
	
	match level_id:
		1: get_tree().change_scene_to_file(level_1_path)
		2: get_tree().change_scene_to_file(level_2_path)
		_: pass


func update_player_ammo(amount : int):
	player_ammo += amount
	if player_ammo > player_ammo_max:
		player_ammo = player_ammo_max
	
	change_player_ammo.emit()
	pass

func game_over():
	end_game.emit()
	get_tree().paused = true
	pass


func update_music_volume(value : float):
	music_volume_adjust = value
	AudioServer.set_bus_volume_db(music, linear_to_db(value))


func update_sfx_volume(value : float):
	sfx_volume_adjust = value
	AudioServer.set_bus_volume_db(sfx, linear_to_db(value))
