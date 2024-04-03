extends Node2D


const lines = [
	"Some slimes are friendly.",
	"Try stepping on this one!"
]

const sounds = [
	"res://assets/sfx/narrator/l2_1.mp3",
	"res://assets/sfx/narrator/l2_2.mp3"
]
var is_playing = false


func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines, sounds)
		is_playing = true
