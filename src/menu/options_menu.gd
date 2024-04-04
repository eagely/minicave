extends Menu

signal open_keybinds
signal toggle_camera_shake(state: bool)

@onready var fullscreen = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/FullscreenCheck
@onready var screen_shake = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/ScreenShakeCheck
@onready var disable_dialog = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/DisableDialogCheck
@onready var music_volume = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/MusicVolumeContainer/MusicVolumeSlider
@onready var sfx_volume = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/SfxVolumeContainer/SfxVolumeSlider
@onready var narrator_volume = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/NarratorVolumeContainer/NarratorVolumeSlider

func _ready():
	var video = ConfigFileHandler.load_video_settings()
	fullscreen.button_pressed = video.fullscreen
	screen_shake.button_pressed = video.screen_shake
	disable_dialog.button_pressed = video.disable_dialog
	
	var audio = ConfigFileHandler.load_audio_settings()
	music_volume.value = audio.master_volume * 100
	sfx_volume.value = audio.sfx_volume * 100
	narrator_volume.value = audio.narrator_volume * 100
	DialogManager.volume = audio.narrator_volume * 100
	var keybinds = ConfigFileHandler.load_keybindings()
	

func _on_keybinding_button_pressed():
	emit_signal("open_keybinds")
	
func _on_fullscreen_check_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
	ConfigFileHandler.save_video_setting("fullscreen", toggled_on)


func _on_screen_shake_check_toggled(toggled_on):
	GameManager.screen_shake_enabled = toggled_on
	ConfigFileHandler.save_video_setting("screen_shake", toggled_on)


func _on_disable_dialog_check_toggled(toggled_on):
	DialogManager.global_disable = toggled_on
	ConfigFileHandler.save_video_setting("disable_dialog", toggled_on)

func _on_back_button_pressed():
	GameManager.back()
	

func _on_music_volume_slider_value_changed(value):
	if GameManager.main:
		for child in GameManager.main.get_node("Music").get_children():
			child.volume_db = value if value > -30 else -80
		ConfigFileHandler.save_audio_setting("master_volume", value / 100)

func _on_sfx_volume_slider_value_changed(value):
	if GameManager.main:
		for child in GameManager.main.get_node("Sfx").get_children():
			child.volume_db = value if value > -30 else -80
			ConfigFileHandler.save_audio_setting("sfx_volume", value / 100)

func _on_narrator_volume_slider_value_changed(value):
	DialogManager.volume = value if value > -30 else -80
	ConfigFileHandler.save_audio_setting("narrator_volume", value / 100)
