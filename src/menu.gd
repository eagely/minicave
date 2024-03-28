extends Control

signal start_game

func _ready():
	pass


func _process(delta):
	pass


func _on_play_pressed():
	emit_signal("start_game")


func _on_options_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()
