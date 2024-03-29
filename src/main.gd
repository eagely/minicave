extends Node

var in_game = false
var menu
var keybinds
var options
var level
var player
var mob_scene = preload("res://scenes/mob.tscn")
var mobs = []

var lvlnum = 1

func _ready():
	menu = $UI/Menu
	keybinds = $UI/KeybindMenu
	options = $UI/OptionsMenu
	level = $Level
	player = $Player
	main_menu()
	set_process_input(true)
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").hide()
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
			if keybinds.visible:
				options_menu()
			elif menu.visible:
				start()
			else:
				main_menu()
	elif Input.is_action_just_pressed("enter"):
			if menu.visible:
				start()

func start():
	if (in_game):
		unpause()
	else:
		player.start($StartPosition.position)
		clear_mobs()
		for spawner in level.get_node("MobSpawners").get_children():
			var mob_instance = mob_scene.instantiate()
			mob_instance.position = spawner.position
			add_child(mob_instance)
			mobs.append(mob_instance)

		unpause()
		in_game = true

func unpause():
	get_tree().paused = false
	keybinds.hide()
	options.hide()
	menu.hide()
	level.show()
	player.show()	
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").show()
	for mob in mobs:
		if is_instance_valid(mob):		
			mob.show()

func main_menu():
	get_tree().paused = true
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").hide()
	level.hide()
	player.hide()
	for mob in mobs:
		if is_instance_valid(mob):
			mob.hide()
	keybinds.hide()
	options.hide()
	menu.show()

func options_menu():
	get_tree().paused = true	
	menu.hide()
	keybinds.hide()
	options.show()

func keybinds_menu():
	options.hide()
	keybinds.show()
	get_tree().paused = true
	
func load_next_level():
	if level.has_node("Tutorial"):
		level.get_node("Tutorial").hide()
	var next = load("res://levels/level" + str(lvlnum) + ".tscn").instantiate()
	var cur = get_node("Level")
	if cur:
		remove_child(cur)
		cur.queue_free()
	next.name = "Level"
	add_child(next)
	level = $Level
	in_game = false
	start()
	lvlnum += 1

func reload_level():
	if level.has_node("Tutorial"):
		var tutorial = level.get_node("Tutorial")
		for label in tutorial.get_children():
			label.get_child("Label").text = ""
		tutorial.get_child("Walk").get_child("Label").text = "Press A or D to walk"
		tutorial.show()
	in_game = false
	start()

func clear_mobs():
	for mob in mobs:
		if is_instance_valid(mob):
			mob.queue_free()
	mobs.clear()

func _on_player_level_completed():
	load_next_level()


func _on_player_died():
	reload_level()
