extends Control

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	emit_signal("start_game")


func _on_options_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()
