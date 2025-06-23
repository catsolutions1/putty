extends Node2D

#@onready var pause_menu = $gui/input_settings

var current_level: int = 1
#var game_paused: bool = false

func _ready() -> void:
	SignalBus.GOAL_REACHED.connect(_level_clear)
	load_level()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("reload_level"):
		load_level()


func load_level() -> void:
	for child in get_children():
		child.queue_free()
	var level = load("res://scenes/levels/level_" + str(current_level) + ".tscn").instantiate()
	call_deferred("add_child", level)
	

func _level_clear() -> void:
	current_level += 1
	load_level()


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("pause"):
		#game_paused = !game_paused
		#if game_paused:
			#Engine.time_scale = 0
			#pause_menu.visible = true
		#else:
			#Engine.time_scale = 1
			#pause_menu.visible = false
		#get_tree().root.get_viewport().set_input_as_handled()
