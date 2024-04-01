extends CharacterBody2D

@onready var player = GameManager.player
@onready var animation = $AnimatedSprite2D

func _ready():
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")

func _physics_process(_delta):
	var direction = player.position - position
	velocity = direction.normalized() * 60
	move_and_slide()

func hit(a):
	queue_free()


func _on_player_detection_body_entered(body):
	if body == GameManager.player:
		body.hit(1)
