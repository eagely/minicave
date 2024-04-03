extends CharacterBody2D

@onready var player = GameManager.player
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = find_child("HealthBar")
@onready var spawnpoint = position

var direction : Vector2
var def = 1.0
var dead = false

var hp: = 100:
	set(value):
		if not dead:
			hp = value
			health_bar.health = value
			if value <= 0:
				health_bar.health = 0
				find_child("FiniteStateMachine").change_state("Death")
				dead = true

func _ready():
	health_bar.health = 100
	set_physics_process(false)


func _process(_delta):
	direction = player.position - position
	
	animated_sprite.flip_h = direction.x < 0
	$MeleeArea/CollisionShape2D.scale.x = abs($MeleeArea/CollisionShape2D.scale.x) * (-1 if direction.x < 0 else 1)

func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)

func hit(dmg):
	hp -= dmg * 0.3

func pause():
	for child in get_children():
		if child is CanvasItem:
			child.hide()
	$UI.hide()
	hide()
	
func unpause():
	for child in get_children():
		if child is CanvasItem:
			child.show()
	$UI.show()
	show()
	
func _on_minion_killed():
	hp += 5
	
