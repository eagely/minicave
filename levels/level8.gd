extends Node2D


const lines = [
	"Until recently, we've been hearing very hushed laughter coming from outside these walls.",
	"I think it might be the creator of the shadow realm, hopefully we can find him soon!",
	"See you soon adventurer, I won't bother you much more."
]

var is_playing = false


func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines)
		is_playing = true
