extends Control

@onready var input_button_scene = preload("res://scenes/ui/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/action_list

var is_remapping: bool = false
var action_to_remap = null
var remapping_button = null

const input_actions: Dictionary = {
	"move_up": "Move Up",
	"move_left": "Move Left",
	"move_down": "Move Down",
	"move_right": "Move Right",
	"delete_random_key": "Delete Key",
	"spacebar": "Space"
}

const deletable_actions: Dictionary = {
	0: "move_up",
	1: "move_left",
	2: "move_down",
	3: "move_right"
}

var allowed_keys: PackedStringArray = [
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"Up",
	"Left",
	"Down",
	"Right"
]

func _ready() -> void:
	InputMap.load_from_project_settings()
	_create_action_list()
	SignalBus.DAMAGE_TAKEN.connect(_select_key_to_delete)


func _create_action_list() -> void:
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("label_action")
		var input_label = button.find_child("label_input")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _update_action_list(button: Button, event: InputEvent) -> void:
	button.find_child("label_input").text = event.as_text().trim_suffix(" (Physical)")


func _on_input_button_pressed(button: Button, action: String) -> void:
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("label_input").text = "Awaiting input..."


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if is_allowed_key(event):
			if is_remapping:
				rebind(event)
			else:
				for i in deletable_actions.size():
					backup_rebind(deletable_actions.get(i), event)


func _select_key_to_delete() -> void:
	var available_actions: Array = []
	for i in deletable_actions.size():
		if InputMap.action_get_events(deletable_actions.get(i)) != []:
			available_actions.append(deletable_actions.get(i))
	
	var x = available_actions.pick_random()
	if x != null:
		delete_key(x)
	else:
		print("you lose")


func delete_key(action: String) -> void:
	if InputMap.action_get_events(action):
		for i in allowed_keys.size():
			if allowed_keys[i] == InputMap.action_get_events(action)[0].as_text_physical_keycode():
				allowed_keys.remove_at(i)
				break
		
		InputMap.action_erase_event(action, InputMap.action_get_events(action)[0])
		is_remapping = false
		_on_input_button_pressed(action_list.get_children()[deletable_actions.find_key(action)], action)


func rebind(event: InputEvent) -> void:
	for i in deletable_actions.size():
		if InputMap.action_has_event(deletable_actions.get(i), event):
			return
	
	InputMap.action_erase_events(action_to_remap)
	InputMap.action_add_event(action_to_remap, event)
	_update_action_list(remapping_button, event)
	
	is_remapping = false
	action_to_remap = null
	remapping_button = null
	
	accept_event()


func backup_rebind(action: String, event: InputEvent) -> void:
	var other_actions: PackedStringArray = []
	for i in deletable_actions.size():
		if action != deletable_actions.get(i):
			other_actions.append(deletable_actions.get(i))
	
	if !InputMap.action_get_events(action):
		for i in other_actions.size():
			if InputMap.action_has_event(other_actions[i], event):
				return
		InputMap.action_add_event(action, event)
		_update_action_list(action_list.get_children()[deletable_actions.find_key(action)], event)
		accept_event()


func is_allowed_key(event: InputEvent) -> bool:
	for i in allowed_keys.size():
		if event.as_text_physical_keycode() == allowed_keys[i]:
			return true
	return false
