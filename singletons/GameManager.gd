extends Node

const ITEM_TO_SLOT_INDEX = {
	"teleportation": 0,
	"leaping": 1,
	"strength": 2
}

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
	
	# Progress stuff
	if menu.name == "Shop" and player:
		player.get_node("UI").get_node("Hotbar").show()


func back():
	if cur_menu.name == "KeybindMenu":
		open(main.options)
	elif cur_menu.name == "OptionsMenu":
		open(main.title_screen)
	else:
		open(last_menu)


func add_item(name):
	player.items[name] += 1
	if player.items[name] > 0:
		player.get_node("UI").get_node("Hotbar").slots[ITEM_TO_SLOT_INDEX[name]].show_full()
	
func remove_item(name):
	player.items[name] -= 1
	if player.items[name] <= 0:	
		player.get_node("UI").get_node("Hotbar").slots[ITEM_TO_SLOT_INDEX[name]].show_empty()
		player.items[name] = 0
	
