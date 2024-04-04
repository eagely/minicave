extends Node2D


@onready var lines = [
	"Quick! You feel it too, right?",
	"I see a big rock in the shadow realm, maybe that's causing it. You need to destroy it.",
	"I pulled out my old shrinking potion recipe, hopefully these can help you.",
	"You know how ants can carry 50 times their bodyweight?",
	"Well, the shrinking potion makes you really small, in turn making you really strong, but also vulnerable.",
	"You can unshrink by pressing " + ConfigFileHandler.get_display_name(ConfigFileHandler.load_keybindings().unshrink),
	"Make it back safely!"
]

const sounds = [
	preload("res://assets/sfx/narrator/l4_1.mp3"),
	preload("res://assets/sfx/narrator/l4_2.mp3"),
	preload("res://assets/sfx/narrator/l4_3.mp3"),
	preload("res://assets/sfx/narrator/l4_4.mp3"),
	preload("res://assets/sfx/narrator/l4_5.mp3"),
	preload("res://assets/sfx/narrator/l4_6.mp3"),
	preload("res://assets/sfx/narrator/l4_7.mp3")	
]

var is_playing = false

func _process(delta):
	GameManager.shake_screen(5)

func _on_start_body_entered(body):
	if not is_playing and body == GameManager.player:
		DialogManager.start_dialog($Shopkeeper.global_position + Vector2(0, -64), lines, sounds)
		is_playing = true
