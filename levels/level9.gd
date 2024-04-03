extends Node2D


const lines = [
	"Good to see you again.",
	"I keep hearing sounds from the shadow realm.",
	"Constant \"WHOOP\" ringing in my ear.",
	"I suspect there is something dangerous nearby, and it might be teleporting.",
	"Luckily I just finished creating my brand new teleportation potion.",
	"That's also how I'm always ahead of you.",
	"This is quite a revolutionary invention and requires lots of rare Slimium to brew.",
	"Which is why it's going to cost you 200 coins, I'm sorry, but that's the best I can offer."
]

var is_playing = false


func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines)
		is_playing = true
