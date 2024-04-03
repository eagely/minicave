extends CharacterBody2D

const teleport_positions = [
	Vector2(128, 960),
	Vector2(1792, 960),
	Vector2(1536, 256),
	Vector2(512, 320),
	Vector2(1280, 192)
]

@onready var animation = $Animation
@onready var hitbox = $Hitbox
@onready var minion_scene = preload("res://scenes/boss/final/minion.tscn")


func _on_telport_timer_timeout():
	var actual_teleport_positions = teleport_positions
	actual_teleport_positions.remove_at(teleport_positions.find(global_position))
	global_position = actual_teleport_positions[randi() % 4]
	animation.play("default")
	await animation.animation_finished
	var minion = minion_scene.instantiate()
	minion.position = global_position
	minion.dmg = 25
	GameManager.main.get_node("TemporaryElements").add_child(minion_scene.instantiate())
