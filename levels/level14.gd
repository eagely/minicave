extends Node2D


const lines = [
	"I heard there is something extremely dangerous ahead.",
	"Something never before seen.",
	"Maybe this is the creator of the shadow realm.",
	"I stocked up on potions for you, make sure to heavily prepare yourself.",
]

var is_playing = false

func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines)
		is_playing = true
