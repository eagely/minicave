extends Node

var in_game = false
var menu
var keybinds
var level
var player

func _ready():
	menu = $UI/Menu
	keybinds = $UI/KeybindMenu
	level = $Level
	player = $Player
	level.visible = false	
	player.visible = false
	
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		pause()

func _on_menu_start_game():
	if (in_game):
		unpause()
	else:
		start()
		in_game = true

func _on_menu_open_keybinds():
	pause()
	menu.hide()
	keybinds.show()

func start():
	player.start($StartPosition.position)
	unpause()
		
func pause():
	player.pause()
	level.hide()
	keybinds.hide()
	menu.show()
	
func unpause():
	menu.hide()
	level.show()
	player.unpause()



