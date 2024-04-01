extends Node2D


const lines = [
	"Hello again.",
	"See those tiny little slimes?",
	"I know they hurt quite a bit but they also drop coins!",
	"I suggest you save up a little for the future, who knows what could happen ;D"
]


func _on_start_body_entered(body):
	if body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines)
