extends Node2D


@onready var tilemap = $Terrain as TileMap

func start_phase_two(bought_for_cheap):
	var lines
	var sounds
	if bought_for_cheap:
		lines = [
			"Oh you really thought you could scam me like that and get away?",
			"Did you think I wouldn't notice that you bought my potions for basically nothing?",
			"You're very well aware of how much they cost me to brew.",
			"I made a mistake with the pricing and I made a mistake trusting you.",
			"Good thing I have a remote disabler for all potions and abilities.",
			"NOW YOU ARE GOING TO PAY THE ULTIMATE PRICE!"
		]
		sounds = [
			preload("res://assets/sfx/narrator/l15_1_Y.mp3"),
			preload("res://assets/sfx/narrator/l15_2_Y.mp3"),
			preload("res://assets/sfx/narrator/l15_3_Y.mp3"),
			preload("res://assets/sfx/narrator/l15_4_Y.mp3"),
			preload("res://assets/sfx/narrator/l15_5_Y.mp3"),
			preload("res://assets/sfx/narrator/l15_6_Y.mp3")
		]
	else:
		lines = [
			"Did you really think that was the final boss?",
			"Now it's time for your final test. And you're not going to be using any of these potions.",
			"Or any of those abilities.",
			"Good luck on your exam."
		]
		sounds = [
			preload("res://assets/sfx/narrator/l15_1_N.mp3"),
			preload("res://assets/sfx/narrator/l15_2_N.mp3"),
			preload("res://assets/sfx/narrator/l15_3_N.mp3"),
			preload("res://assets/sfx/narrator/l15_4_N.mp3")			
		]
	GameManager.abilities_unlocked.ATTACK_SPEED = false
	GameManager.abilities_unlocked.HEALING = false
	GameManager.abilities_unlocked.STRENGTH = false
	GameManager.player.bullet_count = 1
	remove_child(get_node("Boss"))
	for _i in range(5):
		GameManager.player.perform_unshrink()
	var shopkeeper = load("res://scenes/boss/final/shopkeeper_boss.tscn").instantiate()
	shopkeeper.global_position = Vector2(960, 512)
	shopkeeper.name = "ShopkeeperBoss"
	GameManager.remove_item("teleportation", GameManager.items.teleportation)
	GameManager.remove_item("leaping", GameManager.items.leaping)
	GameManager.remove_item("shrinking", GameManager.items.shrinking)	
	add_child(shopkeeper)

	DialogManager.start_dialog(shopkeeper.global_position + Vector2(0, -64), lines, sounds)
