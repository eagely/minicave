extends CharacterBody2D

@onready var player = GameManager.player
@onready var sprite = $Sprite2D
@onready var health_bar = find_child("HealthBar")
@onready var fsm = find_child("FiniteStateMachine")
@onready var spawnpoint = position

var direction: Vector2
var def = 1.0
var hp = 100:
	set(value):
		hp = value
		health_bar.health = value
		if value <= 0:
			health_bar.hide()
			fsm.change_state("Death")
		elif value <= 50 and def == 1.0:
			def = 0.5
			fsm.change_state("ArmorBuff")

func _ready():
	health_bar.health = 100
	set_physics_process(false)

func _process(delta):
	direction = player.position - position
	
	sprite.flip_h = direction.x < 0
	$MeleeArea/CollisionShape2D.position.x = -$MeleeArea/CollisionShape2D.position.x
	
func _physics_process(delta):
	velocity = direction.normalized() * 80
	move_and_collide(velocity * delta)
	
func hit(damage):
	hp -= damage * def * 0.1
