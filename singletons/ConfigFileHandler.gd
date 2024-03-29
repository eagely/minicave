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
		
		config.save(CONFIG_FILE)
	else:
		config.load(CONFIG_FILE)
		
func save_keybind(key, value):
	config.set_value("keybind", key, value)
	config.save(CONFIG_FILE)
	
func load_keybindings():
	var keybindings = {}
	for key in config.get_section_keys("keybind"):
		keybindings[key] = config.get_value("keybind", key)
	return keybindings
	
func save_video_setting(key, value):
	config.set_value("video", key, value)
	config.save(CONFIG_FILE)
	
func load_video_settings():
	var keybindings = {}
	for key in config.get_section_keys("video"):
		keybindings[key] = config.get_value("vidoe", key)
	return keybindings
	
func save_audio_setting(key, value):
	config.set_value("audio", key, value)
	config.save(CONFIG_FILE)
	
func load_audio_settings():
	var keybindings = {}
	for key in config.get_section_key("audio"):
		keybindings[key] = config.get_value("audio", key)
	return keybindings
