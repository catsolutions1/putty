extends CharacterBody2D

@onready var movement = $component_velocity

var x: int = 0

func _physics_process(_delta: float) -> void:
	set_velocity(movement.find_velocity())
	move_and_slide()
	
	if Input.is_action_just_pressed("delete_random_key"):
		SignalBus.DAMAGE_TAKEN.emit()
