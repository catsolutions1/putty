extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") || body.is_in_group("enemy"):
		SignalBus.emit_signal("BUTTON_TOGGLED")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") || body.is_in_group("enemy"):
		SignalBus.emit_signal("BUTTON_TOGGLED")
