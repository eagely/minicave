extends Node

var in_game = false
@onready var title_screen = $UI/TitleScreen
@onready var keybinds = $UI/KeybindMenu
@onready var options = $UI/OptionsMenu
var level
var player
var mob_scene = preload("res://scenes/mob.tscn")
var mobs = []

func _ready():
	GameManager.main = self
	level = $Level
	player = $Player
	GameManager.load_next_level()
	show_title_screen()
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").hide()
	player.hide_health_bar()

func start_or_continue():
	if in_game:
		unpause()
	else:
		start_new()
		in_game = true

func start_new():
	player.start($StartPosition.position)
	clear_mobs()
	for spawner in level.get_node("MobSpawners").get_children():
		var mob_instance = mob_scene.instantiate()
		mob_instance.position = spawner.position
		add_child(mob_instance)
		mobs.append(mob_instance)
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
	level.hide()
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").hide()
	player.hide()
	player.get_node("UI").hide()
	for mob in mobs:
		if is_instance_valid(mob):
			mob.hide()
	GameManager.open(title_screen)

func show_options():
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
	start_new()

func clear_mobs():
	for mob in mobs:
		if is_instance_valid(mob):
			mob.queue_free()
	mobs.clear()

func _on_player_level_completed():
	GameManager.load_next_level()

func _on_player_died():
	reload_level()
	
func hide_all_non_menus():
	level.hide()
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").hide()
	player.hide()
	player.get_node("UI").hide()
	for mob in mobs:
		if is_instance_valid(mob):
			mob.hide()
			
func _input(event):
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		if keybinds.visible:
			show_options()
		elif title_screen.visible:
			start_or_continue()
		else:
			show_title_screen()
	elif event.is_action_pressed("ui_accept") and not event.is_echo():
		if title_screen.visible:
			start_or_continue()

func _on_title_screen_open_options():
	GameManager.open(options)

func _on_options_menu_open_keybinds():
	GameManager.open(keybinds)
