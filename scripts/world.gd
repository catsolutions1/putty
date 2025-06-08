extends Node2D

@onready var player = $player
@onready var pause_menu = $gui/input_settings

var game_paused: bool = false

func _ready() -> void:
	player.damage_taken.connect(pause_menu.delete_key)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
		if game_paused:
			Engine.time_scale = 0
			pause_menu.visible = true
		else:
			Engine.time_scale = 1
			pause_menu.visible = false
		get_tree().root.get_viewport().set_input_as_handled()
