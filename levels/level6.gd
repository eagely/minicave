extends Node2D


const lines = [
	"You've done it! The shaking has calmed thanks to you.",
	"As a reward, my shrinking potions are now permanently priced at 50 coins.",
]

const sounds = [
	preload("res://assets/sfx/narrator/l6_1.mp3"),
	preload("res://assets/sfx/narrator/l6_2.mp3")
]

var is_playing = false


func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines, sounds)
		is_playing = true
