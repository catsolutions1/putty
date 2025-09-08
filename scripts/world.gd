extends Node2D

var current_level: int = 1
var max_level: int = 10

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
	if current_level > max_level:
		for child in get_children():
			child.queue_free()
		var level = load("res://scenes/win.tscn").instantiate()
		call_deferred("add_child", level)
	else:
		load_level()
