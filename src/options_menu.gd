extends Control

signal open_keybinds
signal toggle_camera_shake(state: bool)

func _ready():
	pass


func _process(delta):
	pass


func _on_keybinding_button_pressed():
	emit_signal("open_keybinds")


func _on_fullscreen_check_toggled(toggled_on):
		if toggled_on == true:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		if toggled_on == false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_screen_shake_check_toggled(toggled_on):
	emit_signal("toggle_camera_shake", toggled_on)
