extends Control

@onready var close: Button = $info/Close
@onready var next: Button = $controls/next

@onready var controls: Panel = $controls
@onready var info: Panel = $info


func _ready() -> void:
	close.pressed.connect(close_window)
	next.pressed.connect(flip)
	
	if GameMaster.display_tutorial == true:
		GameMaster.display_tutorial = false
		open_window()
	


func open_window():
	visible = true

func close_window():
	visible = false


func flip():
	controls.visible = false
	info.visible = true
	pass
