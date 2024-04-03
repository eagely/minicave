extends Node2D


const lines = [
	"You might be wondering how you can get up this ledge.",
	"Luckily, I just brewed some more leaping potions.",
	"You can interact with me to open my shop. For you I'll do 50 coins."
]

var is_playing = false


func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines)
		is_playing = true
