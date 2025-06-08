extends CharacterBody2D

@onready var movement = $component_velocity

var x: int = 0

signal damage_taken(key_to_delete)

func _physics_process(_delta: float) -> void:
	set_velocity(movement.find_velocity())
	move_and_slide()
	
	if Input.is_action_just_pressed("delete_random_key"):
		x = randi_range(0,3)
		damage_taken.emit(x)
