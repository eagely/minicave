extends Node


var config = ConfigFile.new()
const CONFIG_FILE = "user://settings.ini"

func _ready():
	if not FileAccess.file_exists(CONFIG_FILE):
		config.set_value("keybind", "move_left", "a")
		config.set_value("keybind", "move_right", "d")
		config.set_value("keybind", "jump", "space")
		config.set_value("keybind", "interact", "e")
		config.set_value("keybind", "duck", "shift")
		config.set_value("video", "fullscreen", true)
		config.set_value("video", "screen_shake", true)
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)	
		config.save(CONFIG_FILE)
	else:
		config.load(CONFIG_FILE)
		
func save_keybind(action: StringName, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)

	config.set_value("keybinding", action, event_str)
	config.save(CONFIG_FILE)
	
func load_keybindings():
	var keybindings = {}
	for key in config.get_section_keys("keybinding"):
		var input_event
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		
		keybindings[key] = input_event
	return keybindings

	
func save_video_setting(key, value):
	config.set_value("video", key, value)
	config.save(CONFIG_FILE)
	
func load_video_settings():
	var keybindings = {}
	for key in config.get_section_keys("video"):
		keybindings[key] = config.get_value("video", key)
	return keybindings
	
func save_audio_setting(key, value):
	config.set_value("audio", key, value)
	config.save(CONFIG_FILE)
	
func load_audio_settings():
	var keybindings = {}
	for key in config.get_section_keys("audio"):
		keybindings[key] = config.get_value("audio", key)
	return keybindings
