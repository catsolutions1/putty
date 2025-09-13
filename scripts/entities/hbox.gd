extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@export var scaling: int = 1

var input_direction: Vector2 = Vector2.ZERO
const tile_size: Vector2 = Vector2(16, 16)
var sprite_node_pos_tween: Tween

const movement_map: Dictionary = {
	"move_left": {"collider": "ray_right", "direction": Vector2.LEFT},
	"move_right": {"collider": "ray_left", "direction": Vector2.RIGHT}
}

func _physics_process(_delta: float) -> void:
	input_direction = get_input_direction(movement_map)
	if input_direction != Vector2.ZERO:
		update_position(input_direction)


func get_input_direction(movement_map: Dictionary) -> Vector2:
	for action_name in movement_map:
		if Input.is_action_pressed(action_name):
			var data = movement_map[action_name]
			if get_node(movement_map[action_name].collider).is_colliding():
				return data.direction
	return Vector2.ZERO


func update_position(dir: Vector2) -> void:
	if !sprite_node_pos_tween || !sprite_node_pos_tween.is_running():
		self.global_position += dir * tile_size * scaling
		sprite.global_position -= dir * tile_size * scaling
		
		if sprite_node_pos_tween:
			sprite_node_pos_tween.kill()
		sprite_node_pos_tween = create_tween()
		sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		sprite_node_pos_tween.tween_property(sprite, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)
