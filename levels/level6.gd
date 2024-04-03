extends Node2D


const lines = [
	"You've done it! The shaking has calmed thanks to you.",
	"As a reward, my strength potions are now permanently priced at 100 coins.",
]

var is_playing = false


func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines)
		is_playing = true
