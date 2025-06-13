extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
var input_direction: Vector2 = Vector2.ZERO

var movement_map: Dictionary = {
	"move_up": {"collider": "ray_down", "direction": Vector2.UP},
	"move_left": {"collider": "ray_right", "direction": Vector2.LEFT},
	"move_down": {"collider": "ray_up", "direction": Vector2.DOWN},
	"move_right": {"collider": "ray_left", "direction": Vector2.RIGHT}
}

func _physics_process(_delta: float) -> void:
	input_direction = get_input_direction()
	$grid_movement.update_position(input_direction)
	
	if Input.is_action_just_pressed("delete_random_key"):
		SignalBus.DAMAGE_TAKEN.emit()


func get_input_direction() -> Vector2:
	for action_name in movement_map:
		if Input.is_action_pressed(action_name):
			var data = movement_map[action_name]
			if !get_node(movement_map[action_name].collider).is_colliding():
				return data.direction
	return Vector2.ZERO
