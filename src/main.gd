extends Node

var in_game = false
var in_keybinds = false
var in_menu = true
var in_options = false
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
	
func _process(delta):
	if Input.is_action_just_pressed("escape"):
			if in_keybinds:
				options_menu()
			elif in_menu:
				start()
			else:
				main_menu()
	elif Input.is_action_just_pressed("enter"):
			if in_menu:
				start()

func start():
	if (in_game):
		unpause()
	else:
		player.start($StartPosition.position)
		mobs.clear()
		for spawner in level.get_node("MobSpawners").get_children():
			var mob_instance = mob_scene.instantiate()
			mob_instance.position = spawner.position
			add_child(mob_instance)
			mobs.append(mob_instance)

		unpause()
		in_game = true
	in_menu = false

func unpause():
	get_tree().paused = false
	keybinds.hide()
	options.hide()
	menu.hide()
	level.show()
	player.show()
	for mob in mobs:
		if is_instance_valid(mob):		
			mob.show()

func main_menu():
	get_tree().paused = true	
	level.hide()
	player.hide()
	for mob in mobs:
		if is_instance_valid(mob):
			mob.hide()
	keybinds.hide()
	options.hide()
	menu.show()
	in_menu = true
	in_options = false

func options_menu():
	get_tree().paused = true	
	menu.hide()
	keybinds.hide()
	options.show()
	in_options = true
	in_keybinds = false
	in_menu = false

func keybinds_menu():
	options.hide()
	keybinds.show()
	get_tree().paused = true
	in_keybinds = true
	in_options = false
	
func load_next_level():
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
	

func clear_mobs():
	for mob in mobs:
		if is_instance_valid(mob):
			mob.queue_free()
	mobs.clear()

func _on_player_level_completed():
	load_next_level()
