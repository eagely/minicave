extends Menu

signal start_game
signal open_options
signal open_select_level

func _on_play_pressed():
	emit_signal("start_game")


func _on_options_pressed():
	emit_signal("open_options")

func _on_tutorial_pressed():
	GameManager.play_tutorial()

func hover_sound():
	GameManager.sound("hover")


func _on_select_level_pressed():
	emit_signal("open_select_level")
