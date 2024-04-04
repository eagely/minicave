extends SpinBox

func _on_value_changed(value):
	GameManager.cur_level = value
	GameManager.main.load_level()
