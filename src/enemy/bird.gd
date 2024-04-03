extends CharacterBody2D

var speed = 200

@onready var animation = $Animation

func _ready():
	animation.play("fly")

func _physics_process(delta):
	var direction = (GameManager.player.global_position - global_position).normalized()
	velocity = direction * speed
	animation.flip_h = velocity.x < 0
	move_and_slide()

