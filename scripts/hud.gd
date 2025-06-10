extends Control

@onready var label_scene = preload("res://scenes/ui/debug_label_input.tscn")
@onready var action_list = $VBoxContainer

const input_actions: Dictionary = {
	"move_up": "Move Up",
	"move_left": "Move Left",
	"move_down": "Move Down",
	"move_right": "Move Right"
}

func _ready() -> void:
	InputMap.load_from_project_settings()


func _process(_delta: float) -> void:
	_create_action_list()


func _create_action_list() -> void:
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var label = label_scene.instantiate()
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			label.set("theme_override_font_sizes/font_size", 8)
			label.set("texture_filter", "nearest")
			label.text = input_actions[action] + ": " + events[0].as_text()
		else:
			label.text = ""
		
		action_list.add_child(label)
