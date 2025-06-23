extends Node2D

var goal_scene = preload("res://scenes/entities/goal.tscn")
@export var goal_position: Vector2 = Vector2(216,88)

func _ready() -> void:
	SignalBus.ENEMY_DEFEATED.connect(_check_enemy_list)


func _check_enemy_list() -> void:
	for body in $playable_space.get_overlapping_bodies():
		if !body.is_in_group("player") && !body.is_in_group("wall"):
			return
	var goal = goal_scene.instantiate()
	goal.global_position = goal_position
	add_child(goal)
