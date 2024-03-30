extends Node

var main
var player
var mobs = []
var cur_level = 1
var cur_menu = null
var last_menu = null

func play_tutorial():
	main.in_game = true
	main.load_level(0)
	
func stop_tutorial():
	cur_level -= 1
	load_next_level()
	main.hide_all_non_menus()
	open(main.title_screen)

func load_next_level():
	if main.level.has_node("Tutorial"):
		main.level.get_node("Tutorial").hide()
	main.load_level(GameManager.cur_level)
	cur_level += 1

func open(menu: Menu):
	if cur_menu:
		close(cur_menu)
	cur_menu = menu
	menu._on_open()
	
func close(menu: Menu):
	last_menu = cur_menu		
	cur_menu = null
	menu._on_close()
	
func back():
	if cur_menu.name == "KeybindMenu":
		open(main.options)
	elif cur_menu.name == "OptionsMenu":
		open(main.title_screen)
	else:
		open(last_menu)
