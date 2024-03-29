extends Control

signal start_game
signal open_options

func _ready():
	pass


func _process(delta):
	pass


func _on_play_pressed():
	emit_signal("start_game")


func _on_options_pressed():
	emit_signal("open_options")


func _on_quit_pressed():
	get_tree().quit()
