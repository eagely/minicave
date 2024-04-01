extends Node2D


const lines = [
	"Hello Adventurer.",
	"Want to get up that ledge?",
	"Try one of my leaping potions!",
	"It's only going to cost you 50 coins!"
]



func _on_interaction_area_body_entered(body):
	if body == GameManager.playrer:
		DialogManager.start_dialog(global_position, lines)
