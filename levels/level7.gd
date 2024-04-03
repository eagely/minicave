extends Node2D


const lines = [
	"Did you know that these golden portals aren't actually portals?",
	"They just transport reality to the shadow realm and transform the level."
]

var is_playing = false


func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines)
		is_playing = true
