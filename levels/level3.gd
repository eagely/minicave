extends Node2D


const lines = [
	"You might be wondering how you can get up this ledge.",
	"Luckily, I just brewed some more leaping potions.",
	"You can interact with me to open my shop. For you I'll do 50 coins."
]

const sounds = [
	"res://assets/sfx/narrator/l3_1.mp3",
	"res://assets/sfx/narrator/l3_2.mp3",
	"res://assets/sfx/narrator/l3_3.mp3"
]

var is_playing = false

func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines, sounds)
		is_playing = true

