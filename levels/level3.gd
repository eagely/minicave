extends Node2D

var keybinds = ConfigFileHandler.load_keybindings()

@onready var lines = [
	"You might be wondering how you can get up this ledge.",
	"Luckily, I just brewed some more leaping potions.",
	"You can interact with me to open my shop. For you I'll do 50 coins.",
	"To use potions, you can press the hotbar ykeys " + ConfigFileHandler.get_display_name(keybinds.hotbar_1) + ", " + ConfigFileHandler.get_display_name(keybinds.hotbar_2) + " and " + ConfigFileHandler.get_display_name(keybinds.hotbar_3) + "."
]

const sounds = [
	preload("res://assets/sfx/narrator/l3_1.mp3"),
	preload("res://assets/sfx/narrator/l3_2.mp3"),
	preload("res://assets/sfx/narrator/l3_3.mp3"),
	preload("res://assets/sfx/narrator/l3_4.mp3")	
]

var is_playing = false

func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines, sounds)
		is_playing = true

