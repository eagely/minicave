extends Node

signal gained_coins(amt)
signal level_loaded(id)

const ITEM_TO_SLOT_INDEX = {
	"teleportation": 0,
	"leaping": 1,
	"strength": 2
}

var items = {
	"teleportation": 0,
	"leaping": 0,
	"strength": 0
}

var coins = 0

var main
var player
var mobs = []
var cur_level = 1
var cur_menu = null
var last_menu = null
var last_song = null
var last_sfx = null

func _ready():
	GameManager.connect("level_loaded", _on_level_loaded)

func play_tutorial():
	main.in_game = true
	main.load_level(0)
	
func stop_tutorial():
	cur_level -= 1
	load_next_level()
	main.hide_all_non_menus()
	open(main.title_screen)

func load_next_level():
	if cur_level > 1:
		fade_in()
	if main.level.has_node("Tutorial"):
		main.level.get_node("Tutorial").hide()
	main.load_level(GameManager.cur_level)
	emit_signal("level_loaded", cur_level)
	cur_level += 1
	if cur_level > 2:
		fade_out()
	
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
	items[name] += 1
	if items[name] > 0:
		player.get_node("UI").get_node("Hotbar").slots[ITEM_TO_SLOT_INDEX[name]].show_full()
	
func remove_item(name):
	items[name] -= 1
	if items[name] <= 0:	
		player.get_node("UI").get_node("Hotbar").slots[ITEM_TO_SLOT_INDEX[name]].show_empty()
		items[name] = 0
		
func gain_coins(coins_gained):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
	
func lose_coins(coins_lost):
	coins -= coins_lost
	emit_signal("gained_coins", -coins_lost)
	
func sound(name):
	if last_sfx:
		main.get_node("Sfx").get_node(last_sfx).stop()
	main.get_node("Sfx").get_node(name).play()
	last_sfx = name
	
func music(name):
	if last_song:
		main.get_node("Music").get_node(last_song).stop()
	main.get_node("Music").get_node(name).play()
	last_song = name
	
func shake_screen():
	player.get_node("Camera").shake()
	
func play_small_hit(pos):
	pass
	
func play_medium_hit(pos):
	pass	

func play_large_hit(pos):
	pass

func frame_freeze(time_scale, duration):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale).timeout
	Engine.time_scale = 1


func boss_slain():
	music("underground")
	main.level.find_child("Finish").enable()
	var pos = main.level.find_child("Boss").global_position
	var coin_offset = 16
	var gray_positions = generate_points(pos.x - coin_offset * 8, pos.x + coin_offset * 8, pos.y, 32)
	var red_positions = generate_points(pos.x - coin_offset * 8 -8, pos.x + coin_offset * 8, pos.y, 32)
	for p in gray_positions:
		var coin = main.gray_coin_scene.instantiate()
		coin.position = p
		add_child(coin)
	for p in red_positions:
		var coin = main.red_coin_scene.instantiate()
		coin.position = p
		add_child(coin)


func _on_level_loaded(id):
	if id % 5 == 0:
		main.level.find_child("Finish").disable()
		music("boss")
		
func generate_points(start_x: float, end_x: float, y: float, n: int) -> Array:
	var points: Array = []
	var step: float = (end_x - start_x) / max(n - 1, 1)
	
	for i in range(n):
		var x: float = start_x + step * i
		points.append(Vector2(x, y))
	
	return points
	
func fade_in():
	var fade = main.find_child("LevelFade")
	fade.show()
	fade.fading_in = true
	await get_tree().create_timer(1).timeout
	fade.fading_in = false
	
func fade_out():
	var fade = main.find_child("LevelFade")
	fade.fading_out = true
	await get_tree().create_timer(1).timeout
	fade.fading_out = false
	fade.hide()
