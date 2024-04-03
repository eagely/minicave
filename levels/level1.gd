extends Node2D


@onready var keybind = ConfigFileHandler.load_keybindings().advance_dialog
const lines = [
	"Good day Adventurer, rarely these days do I see apprentice wizards like you in here.",
	"Luckily for you, I'm working on some new potions, maybe I'll show you later.",
	"For now just follow me into that glowing golden portal.",
	"Avoid those slimes on the way."
]
const sounds = [
	"res://assets/sfx/narrator/l1_1.mp3",
	"res://assets/sfx/narrator/l1_2.mp3",
	"res://assets/sfx/narrator/l1_3.mp3",
	"res://assets/sfx/narrator/l1_4.mp3",
]

var is_playing = false


func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines, sounds)
		is_playing = true
