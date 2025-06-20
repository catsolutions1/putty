extends Node2D

@export var character: CharacterBody2D
@export var scaling: int = 1
@export var sprite: Sprite2D

const tile_size: Vector2 = Vector2(16, 16)
var sprite_node_pos_tween: Tween

func get_input_direction(movement_map: Dictionary) -> Vector2:
	for action_name in movement_map:
		if Input.is_action_pressed(action_name):
			var data = movement_map[action_name]
			if !character.get_node(movement_map[action_name].collider).is_colliding():
				return data.direction
	return Vector2.ZERO


func update_position(dir: Vector2) -> void:
	if !sprite_node_pos_tween || !sprite_node_pos_tween.is_running():
		character.global_position += dir * tile_size * scaling
		sprite.global_position -= dir * tile_size * scaling
		
		if sprite_node_pos_tween:
			sprite_node_pos_tween.kill()
		sprite_node_pos_tween = create_tween()
		sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		sprite_node_pos_tween.tween_property(sprite, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)
