extends Control
class_name Menu

func _on_open():
	get_tree().paused = true
	show()
	
func _on_close():
	hide()
	get_tree().paused = false
