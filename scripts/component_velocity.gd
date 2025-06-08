extends Node2D

@export var speed: int

var velocity = Vector2.ZERO

func find_velocity() -> Vector2:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = direction.normalized()
	
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2(
			move_toward(velocity.x, 0, speed),
			move_toward(velocity.y, 0, speed)
		)
	return velocity
