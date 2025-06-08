extends Control

@onready var input_button_scene = preload("res://scenes/ui/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/action_list

var is_remapping: bool = false
var action_to_remap = null
var remapping_button = null

var input_actions: Dictionary = {
	"move_up": "Move Up",
	"move_left": "Move Left",
	"move_down": "Move Down",
	"move_right": "Move Right",
	"shoot": "Shoot"
}

#known bug: modifier keys can be combined with these to create new key labels
var disabled_keys: PackedStringArray = [
	"Escape",
	"Tab",
	"Backtab",
	"Backspace",
	"Enter",
	"Kp Enter",
	"Insert",
	"Delete",
	"Pause",
	"Print",
	"SysReq",
	"Clear",
	"Home",
	"End",
	"PageUp",
	"PageDown",
	"Shift",
	"Ctrl",
	"Windows",
	"Alt",
	"CapsLock",
	"NumLock",
	"ScrollLock",
	"F1",
	"F2",
	"F3",
	"F4",
	"F5",
	"F6",
	"F7",
	"F8",
	"F9",
	"F10",
	"F11",
	"F12",
	"F13",
	"F14",
	"F15",
	"F16",
	"F17",
	"F18",
	"F19",
	"F20",
	"F21",
	"F22",
	"F23",
	"F24",
	"F25",
	"F26",
	"F27",
	"F28",
	"F29",
	"F30",
	"F31",
	"F32",
	"F33",
	"F34",
	"F35",
	"Kp Multiply",
	"Kp Divide",
	"Kp Subtract",
	"Kp Period",
	"Kp Add",
	"Kp 0",
	"Kp 1",
	"Kp 2",
	"Kp 3",
	"Kp 4",
	"Kp 5",
	"Kp 6",
	"Kp 7",
	"Kp 8",
	"Kp 9",
	"Menu",
	"Hyper",
	"Help",
	"Back",
	"Forward",
	"Stop",
	"Refresh",
	"VolumeDown",
	"VolumeMute",
	"VolumeUp",
	"MediaPlay",
	"MediaStop",
	"MediaPrevious",
	"MediaNext",
	"Media Record",
	"HomePage",
	"Favorites",
	"Search",
	"StandBy",
	"OpenURL",
	"LaunchMail",
	"LaunchMedia",
	"Launch0",
	"Launch1",
	"Launch2",
	"Launch3",
	"Launch4",
	"Launch5",
	"Launch6",
	"Launch7",
	"Launch8",
	"Launch9",
	"LaunchA",
	"LaunchB",
	"LaunchC",
	"LaunchD",
	"LaunchE",
	"LaunchF",
	"Globe",
	"On-screen keyboard",
	"JIS Eisu",
	"JIS Kana",
	"Unknown",
	"Space",
	"Exclam",
	"QuoteDbl",
	"NumberSign",
	"Dollar",
	"Percent",
	"Ampersand",
	"Apostrophe",
	"ParenLeft",
	"ParenRight",
	"Asterisk",
	"Plus",
	"Comma",
	"Minus",
	"Period",
	"Slash",
	"Colon",
	"Semicolon",
	"Less",
	"Equal",
	"Greater",
	"Question",
	"At",
	"BracketLeft",
	"BackSlash",
	"BracketRight",
	"AsciiCircum",
	"UnderScore",
	"QuoteLeft",
	"BraceLeft",
	"Bar",
	"BraceRight",
	"AsciiTilde",
	"Yen",
	"Section",
	#including wasd fixes a bug with the first time you rebind a key
	"W",
	"A",
	"S",
	"D"
]

func _ready() -> void:
	_create_action_list()

func _create_action_list() -> void:
	InputMap.load_from_project_settings()
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

func _on_input_button_pressed(button, action) -> void:
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("label_input").text = "Awaiting input..."

func _input(event: InputEvent) -> void:
	if is_remapping:
		if (event is InputEventKey || event is InputEventMouseButton && event.pressed):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			if event is InputEventKey:
				for i in disabled_keys.size():
					if event.as_text_key_label() == disabled_keys[i]:
						return
			
			if InputMap.action_has_event("move_up", event) || InputMap.action_has_event("move_left", event) || InputMap.action_has_event("move_right", event) || InputMap.action_has_event("move_down", event):
				return
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func _update_action_list(button, event) -> void:
	button.find_child("label_input").text = event.as_text().trim_suffix(" (Physical)")

func delete_key(x) -> void:
	match x:
		0:
			if InputMap.action_get_events("move_up"):
				disabled_keys.append(InputMap.action_get_events("move_up")[0].as_text_key_label())
				InputMap.action_erase_event("move_up", InputMap.action_get_events("move_up")[0])
				is_remapping = false
				_on_input_button_pressed(action_list.get_children()[0], "move_up")
			else:
				delete_key(x + 1)
		1:
			if InputMap.action_get_events("move_left"):
				disabled_keys.append(InputMap.action_get_events("move_left")[0].as_text_key_label())
				InputMap.action_erase_event("move_left", InputMap.action_get_events("move_left")[0])
				is_remapping = false
				_on_input_button_pressed(action_list.get_children()[1], "move_left")
			else:
				delete_key(x + 1)
		2:
			if InputMap.action_get_events("move_down"):
				disabled_keys.append(InputMap.action_get_events("move_down")[0].as_text_key_label())
				InputMap.action_erase_event("move_down", InputMap.action_get_events("move_down")[0])
				is_remapping = false
				_on_input_button_pressed(action_list.get_children()[2], "move_down")
			else:
				delete_key(x + 1)
		3:
			if InputMap.action_get_events("move_right"):
				disabled_keys.append(InputMap.action_get_events("move_right")[0].as_text_key_label())
				InputMap.action_erase_event("move_right", InputMap.action_get_events("move_right")[0])
				is_remapping = false
				_on_input_button_pressed(action_list.get_children()[3], "move_right")
			else:
				if !InputMap.action_get_events("move_up") && !InputMap.action_get_events("move_left") && !InputMap.action_get_events("move_down") && !InputMap.action_get_events("move_right"):
					print("you lose")
				else:
					delete_key(0)
		_:
			print("bug detected")
