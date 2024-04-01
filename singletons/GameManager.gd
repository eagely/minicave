extends Node


signal gained_coins(amt)
signal level_loaded(id)
signal skill_unlocked(name)
signal ability_selected(ability)

const SLOT_INDEX = {
	"teleportation": 0,
	"leaping": 1,
	"strength": 2
}

var items = {
	"teleportation": 0,
	"leaping": 0,
	"strength": 0
}

enum Abilities {
	EXTRA_BULLET,
	ATTACK_SPEED,
	HEALING,
	STRENGTH
}

var abilities_unlocked = {
	"ATTACK_SPEED": false,
	"HEALING": false,
	"STRENGTH": false
}

var coins = 0

var main
var player
var mobs = []
var cur_level = 0
var cur_menu = null
var last_menu = null
var last_song = null
var last_sfx = null
var went_back = false

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
	if cur_level > 0:
		await fade_in()
	went_back = false
	cur_level += 1
	main.load_level(cur_level)
	emit_signal("level_loaded", cur_level)
	main.player.position = main.level.find_child("Start").position
	if cur_level > 1:
		await fade_out()


func open(menu: Menu):
	if cur_menu:
		close(cur_menu)
	cur_menu = menu
	menu._on_open()
	if menu.name != "Shop":
		main.find_child("Background").show()
	if main.level.has_node("Boss"):
		main.level.get_node("Boss").pause()


func close(menu: Menu):
	last_menu = cur_menu		
	cur_menu = null
	menu._on_close()
	
	# Progress stuff
	if menu.name == "Shop" and player:
		player.get_node("UI").get_node("Hotbar").show()
	main.find_child("Background").hide()
	if main.level.has_node("Boss"):
		main.level.get_node("Boss").unpause()


func back():
	if cur_menu.name == "KeybindMenu":
		open(main.options)
	elif cur_menu.name == "OptionsMenu":
		open(main.title_screen)
	else:
		open(last_menu)


func add_item(item_name):
	items[item_name] += 1
	if items[item_name] > 0:
		player.get_node("UI").get_node("Hotbar").slots[SLOT_INDEX[item_name]].show_full()


func remove_item(item_name):
	items[item_name] -= 1
	if items[item_name] <= 0:	
		player.get_node("UI").get_node("Hotbar").slots[SLOT_INDEX[item_name]].show_empty()
		items[item_name] = 0


func gain_coins(coins_gained):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)


func lose_coins(coins_lost):
	coins -= coins_lost
	emit_signal("gained_coins", -coins_lost)
	
func sound(sfx_name):
	if last_sfx and main.get_node("Sfx").has_node(last_sfx):
		main.get_node("Sfx").get_node(last_sfx).stop()
	if main.get_node("Sfx").has_node(sfx_name):
		main.get_node("Sfx").get_node(sfx_name).play()
	last_sfx = sfx_name
	
func music(song_name):
	if last_song and main.get_node("Music").has_node(last_song):
		main.get_node("Music").get_node(last_song).stop()
	if main.get_node("Music").has_node(song_name):
		main.get_node("Music").get_node(song_name).play()
	last_song = song_name
	
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
	main.hide_all_non_menus()
	main.ability_select._update_abilities()
	open(main.ability_select)
	music("underground")
	main.level.find_child("Finish").enable()
	var pos = main.level.find_child("Boss").global_position
	var coin_offset = 16
	var gray_positions = generate_points(pos.x - coin_offset * 8, pos.x + coin_offset * 8, pos.y, 32)
	var red_positions = generate_points(pos.x - coin_offset * 8 -8, pos.x + coin_offset * 8, pos.y, 32)
	for p in gray_positions:
		var coin = main.gray_coin_scene.instantiate()
		coin.position = p
		main.level.get_node("CoinHolder").add_child(coin)
	for p in red_positions:
		var coin = main.red_coin_scene.instantiate()
		coin.position = p
		main.level.get_node("CoinHolder").add_child(coin)
	main.hide_all_non_menus()
	


func _on_level_loaded(id):
	if id % 5 == 0:
		main.level.find_child("Finish").disable()
		music("boss")
	elif last_song == "boss":
		music("underground")
		
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
	fade.find_child("AnimationPlayer").play("fade_in")
	await fade.find_child("AnimationPlayer").animation_finished
	
func fade_out():
	var fade = main.find_child("LevelFade")
	fade.find_child("AnimationPlayer").play("fade_out")
	await fade.find_child("AnimationPlayer").animation_finished
	fade.hide()


func select_ability(key):
	emit_signal("ability_selected", key)
	close(main.get_node("UI").get_node("AbilitySelect"))
	main.show_all_non_menus()
