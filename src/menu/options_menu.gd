extends Menu

signal open_keybinds
signal toggle_camera_shake(state: bool)

@onready var fullscreen = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/FullscreenCheck
@onready var screen_shake = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/ScreenShakeCheck
@onready var master_volume = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/MasterVolumeContainer/MasterVolumeSlider
@onready var sfx_volume = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/SfxVolumeContainer/SfxVolumeSlider

func _ready():
	var video = ConfigFileHandler.load_video_settings()
	fullscreen.button_pressed = video.fullscreen
	screen_shake.button_pressed = video.fullscreen
	
	var audio = ConfigFileHandler.load_audio_settings()
	master_volume.value = audio.master_volume * 100
	sfx_volume.value = audio.sfx_volume * 100
	
	var keybinds = ConfigFileHandler.load_keybindings()
	

func _on_keybinding_button_pressed():
	emit_signal("open_keybinds")
	
func _on_fullscreen_check_toggled(toggled_on):
	ConfigFileHandler.save_video_setting("fullscreen", toggled_on)


func _on_screen_shake_check_toggled(toggled_on):
	ConfigFileHandler.save_video_setting("screen_shake", toggled_on)


func _on_master_volume_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_setting("master_volume", master_volume.value / 100)


func _on_sfx_volume_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_setting("sfx_volume", sfx_volume.value / 100)


func _on_back_button_pressed():
	GameManager.back()
	

