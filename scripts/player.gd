extends CharacterBody2D

const tile_size: Vector2 = Vector2(16, 16)
var sprite_node_pos_tween: Tween

func _physics_process(_delta: float) -> void:
	if !sprite_node_pos_tween || !sprite_node_pos_tween.is_running():
		if Input.is_action_pressed("move_up") && !$up.is_colliding():
			move(Vector2.UP)
		elif Input.is_action_pressed("move_left") && !$left.is_colliding():
			move(Vector2.LEFT)
		elif Input.is_action_pressed("move_down") && !$down.is_colliding():
			move(Vector2.DOWN)
		elif Input.is_action_pressed("move_right") && !$right.is_colliding():
			move(Vector2.RIGHT)
	
	if Input.is_action_just_pressed("delete_random_key"):
		SignalBus.DAMAGE_TAKEN.emit()

func move(dir: Vector2) -> void:
	global_position += dir * tile_size
	$Sprite2D.global_position -= dir * tile_size
	
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($Sprite2D, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)
