extends Node2D


const lines = [
	"Hello Adventurer.",
	"Want to get up that ledge?",
	"Try one of my leaping potions!",
	"It's only going to cost you 50 coins!"
]


func _on_start_body_entered(body):
	if body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines)
