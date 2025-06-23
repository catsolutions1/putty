extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var move_component = $grid_movement
var input_direction: Vector2 = Vector2.ZERO

const movement_map: Dictionary = {
	"move_up": {"collider": "ray_down", "direction": Vector2.UP},
	"move_left": {"collider": "ray_right", "direction": Vector2.LEFT},
	"move_down": {"collider": "ray_up", "direction": Vector2.DOWN},
	"move_right": {"collider": "ray_left", "direction": Vector2.RIGHT}
}

func _physics_process(_delta: float) -> void:
	input_direction = move_component.get_input_direction(movement_map)
	if input_direction != Vector2.ZERO:
		move_component.update_position(input_direction)
