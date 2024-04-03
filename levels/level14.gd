extends Node2D


const lines = [
	"I heard there is something extremely dangerous ahead.",
	"Something never before seen.",
	"Maybe this is the creator of the shadow realm.",
	"I stocked up on potions for you, make sure to heavily prepare yourself.",
]

const sounds = [
	"res://assets/sfx/narrator/l14_1.mp3",
	"res://assets/sfx/narrator/l14_2.mp3",
	"res://assets/sfx/narrator/l14_3.mp3",
	"res://assets/sfx/narrator/l14_4.mp3"
]

var is_playing = false

func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines, sounds)
		is_playing = true
