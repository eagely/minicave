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
		config.set_value("keybind", "hotbar_1", "1")
		config.set_value("keybind", "hotbar_2", "2")
		config.set_value("keybind", "hotbar_3", "3")
		config.set_value("keybind", "cycle_attack_mode", "mouse_3")
		config.set_value("keybind", "advance_dialog", "t")
		config.set_value("keybind", "unshrink", "u")
		config.set_value("video", "fullscreen", true)
		config.set_value("video", "screen_shake", true)
		config.set_value("video", "disable_dialog", false)			
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		config.set_value("audio", "narrator_volume", 1.0)			
		config.save(CONFIG_FILE)
	else:
		config.load(CONFIG_FILE)
		
func save_keybind(action: StringName, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)

	config.set_value("keybind", action, event_str)
	config.save(CONFIG_FILE)
	
func load_keybindings():
	var keybindings = {}
	for key in config.get_section_keys("keybind"):
		var input_event
		var event_str = config.get_value("keybind", key)
		
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
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings
	
func save_audio_setting(key, value):
	config.set_value("audio", key, value)
	config.save(CONFIG_FILE)
	
func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
	
func save_general_setting(key, value):
	config.set_value("general", key, value)
	config.save(CONFIG_FILE)
	
func load_general_settings():
	var general_settings = {}
	for key in config.get_section_keys("general"):
		general_settings[key] = config.get_value("general", key)
	return general_settings
	
func get_display_name(event):
	if event is InputEventMouseButton:
		var index = (event as InputEventMouseButton).button_index
		match index:
			1: 
				return "Left Click"
			2: 
				return "Right Click"
			3:
				return "Middle Click"
			_: return "Mouse_" + str(index)
	else:
		return OS.get_keycode_string(event.keycode)
