extends CharacterBody2D

signal died

@onready var player = GameManager.player
@onready var animation = $AnimatedSprite2D
var dmg = 1
var speed = 60
@onready var spawnlevel = GameManager.cur_level

func _ready():
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")

func _physics_process(_delta):
	print(GameManager.cur_level, spawnlevel)
	if GameManager.cur_level != spawnlevel:
		free()
	else:
		var direction = player.position - position
		velocity = direction.normalized() * speed

		move_and_slide()

func hit(a):
	emit_signal("died")
	queue_free()


func _on_player_detection_body_entered(body):
	if body == GameManager.player:
		body.hit(dmg)
