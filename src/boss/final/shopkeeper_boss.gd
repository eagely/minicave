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
@onready var minion_scene = preload("res://scenes/boss/skeleton/minion.tscn")
@onready var health_bar = $UI/HealthBar
var dead = false
var hp: = 100:
	set(value):
		if not dead:
			hp = value
			health_bar.health = value
			if value <= 0:
				health_bar.health = 0
				dead = true
				GameManager.main.level.get_node("Finish").enable()
				queue_free()
var def = 1.0

func _ready():
	hp = 100
	GameManager.abilities_unlocked = {
	"ATTACK_SPEED": false,
	"HEALING": false,
	"STRENGTH": false
	}

func _on_telport_timer_timeout():
	if DialogManager.is_dialog_active:
		return
	var actual_teleport_positions = teleport_positions
	actual_teleport_positions.remove_at(teleport_positions.find(global_position))
	var pos =  actual_teleport_positions[randi() % 4]
	global_position = pos
	animation.play("default")
	await animation.animation_finished
	var minion = minion_scene.instantiate()
	minion.position = pos
	minion.dmg = 25
	minion.speed = 300
	GameManager.main.get_node("TemporaryElements").add_child(minion)

func hit(dmg):
	if DialogManager.is_dialog_active:
		return
	hp -= dmg * 0.2

