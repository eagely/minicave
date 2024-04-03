extends Node

signal level_loaded(id)

var in_game = false
@onready var title_screen = $UI/TitleScreen
@onready var keybinds = $UI/KeybindMenu
@onready var options = $UI/OptionsMenu
@onready var ability_select = $UI/AbilitySelect
var level
var player
var mob_scene = preload("res://scenes/enemy/mob.tscn")
var coin_scene = preload("res://scenes/shop/coin.tscn")
var red_coin_scene = preload("res://scenes/shop/red_coin.tscn")
var gray_coin_scene = preload("res://scenes/shop/gray_coin.tscn")
var mobs = []
var coins = []

func _ready():
	GameManager.main = self
	level = $Level
	player = $Player
	GameManager.load_next_level()
	hide_all_non_menus()
	show_title_screen()
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").hide()
	player.hide_health_bar()
	GameManager.music("underground")


func start_or_continue():
	if in_game:
		unpause()
	else:
		start_new()
		in_game = true

func start_new():
	player.start(level.get_node("Start").position)
	clear_mobs()
	for spawner in level.get_node("MobSpawners").get_children():
		if spawner.position == Vector2.ZERO:
			pass
		var mob_instance = mob_scene.instantiate()
		mob_instance.position = spawner.position
		add_child(mob_instance)
		mobs.append(mob_instance)
		mob_instance.connect("died", _on_mob_died)
	coins.clear()
	if level.has_node("CoinHolder"):
		for coin in level.get_node("CoinHolder").get_children():
			coins.append([coin.global_position, coin.name])
	unpause()

func unpause():
	get_tree().paused = false
	GameManager.close(title_screen)
	GameManager.close(options)
	GameManager.close(keybinds)
	level.show()
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").show()
	player.show()
	player.get_node("UI").show()
	for mob in mobs:
		if is_instance_valid(mob):
			mob.show()
	

func show_title_screen():
	get_tree().paused = true
	hide_all_non_menus()
	GameManager.open(title_screen)

func show_options():
	hide_all_non_menus()
	GameManager.open(options)

func load_level(id):
	var next = load("res://levels/level" + str(id) + ".tscn").instantiate()
	var cur = get_node("Level")
	if cur:
		remove_child(cur)
		cur.queue_free()
	next.name = "Level"
	add_child(next)
	level = $Level
	start_new()
	
func reload_level():
	if level.has_node("Tutorial"):
		var tutorial = level.get_node("Tutorial")
		for label in tutorial.get_children():
			label.get_child("Label").text = ""
		tutorial.get_child("Walk").get_child("Label").text = "Press A or D to walk"
		tutorial.show()
	if level.has_node("CoinHolder"):
		for coin in level.find_child("CoinHolder").get_children():
			coin.queue_free()
		for coin in coins:
			match str(coin[1])[0]:
				"C":
					var new = coin_scene.instantiate()
					new.global_position = coin[0]
					new.name = coin[1]					
					level.get_node("CoinHolder").add_child(new)
				"G":
					var new = gray_coin_scene.instantiate()
					new.global_position = coin[0]
					new.name = coin[1]
					level.get_node("CoinHolder").add_child(new)
				"R":
					var new = red_coin_scene.instantiate()
					new.global_position = coin[0]
					new.name = coin[1]					
					level.get_node("CoinHolder").add_child(new)
	if level.has_node("Boss"):
		var boss = level.get_node("Boss")
		boss.position = boss.spawnpoint
		boss.def = 1.0
		boss.hp = 100
		for bullet in boss.get_children():
			if bullet.name.contains("Bullet"):
				bullet.queue_free()
	start_new()


func clear_mobs():
	for mob in mobs:
		if is_instance_valid(mob):
			mob.queue_free()
	mobs.clear()


func _on_player_died():
	reload_level()


func hide_all_non_menus():
	get_tree().paused = true
	level.hide()
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").hide()
	player.hide()
	player.get_node("UI").hide()
	for mob in mobs:
		if is_instance_valid(mob):
			mob.hide()
	if level.has_node("Boss"):
		level.get_node("Boss").pause()
	for child in find_child("TemporaryElements").get_children():
		child.hide()
	InteractionManager.hide_all()


func show_all_non_menus():
	level.show()
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").show()
	player.show()
	player.get_node("UI").show()
	for mob in mobs:
		if is_instance_valid(mob):
			mob.show()
	if level.has_node("Boss"):
		level.get_node("Boss").unpause()
	for child in find_child("TemporaryElements").get_children():
		child.show()
	InteractionManager.show_all()
	get_tree().paused = false
			
func _input(event):
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		if GameManager.cur_menu and GameManager.cur_menu.name == "Shop":
			GameManager.close(GameManager.cur_menu)
		elif GameManager.cur_menu and GameManager.cur_menu.name == "AbilitySelect":
			pass
		elif keybinds.visible:
			show_options()
		elif title_screen.visible:
			start_or_continue()
		else:
			show_title_screen()
	elif event.is_action_pressed("ui_accept") and not event.is_echo():
		if title_screen.visible:
			start_or_continue()


func _on_title_screen_open_options():
	hide_all_non_menus()	
	GameManager.open(options)


func _on_options_menu_open_keybinds():
	hide_all_non_menus()
	GameManager.open(keybinds)


func _on_mob_died(pos, type):
	if not level.has_node("CoinHolder"):
		var node = Node2D.new()
		node.name = "CoinHolder"
		level.add_child(node)
	var holder = level.find_child("CoinHolder")
	var coin_offset = 16
	var positions = [
		pos - Vector2(coin_offset * 2, 0), # 2 positions to the left
		pos - Vector2(coin_offset, 0),     # 1 position to the left
		pos,                               # Original position
		pos + Vector2(coin_offset, 0),     # 1 position to the right
		pos + Vector2(coin_offset * 2, 0)  # 2 positions to the right
	]

	match type:
		0:
			for i in range(positions.size()):
				var coin = coin_scene.instantiate()
				coin.position = positions[i]
				holder.add_child(coin)
		2:
			for i in range(positions.size()):
				var coin = coin_scene.instantiate() if i != 2 else red_coin_scene.instantiate()
				coin.position = positions[i]
				holder.add_child(coin)
		1:
			for i in range(positions.size()):
				var coin
				if i == 1 or i == 3:
					coin = gray_coin_scene.instantiate()
				else:
					coin = coin_scene.instantiate()
				coin.position = positions[i]
				holder.add_child(coin)
