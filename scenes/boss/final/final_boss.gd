extends CharacterBody2D

@onready var player = GameManager.player
@onready var sprite = $Sprite2D
@onready var health_bar = owner.find_child("HealthBar")
@onready var spawnpoint = global_position
var direction : Vector2
var dead = false
var def = 1.0

var hp = 100.0:
	set(value):
		if not dead and value <= 100.0:
			if value < hp:
				find_child("FiniteStateMachine").change_state("Stagger")
			
			hp = value
			health_bar.health = value
			
			if value <= 0:
				find_child("FiniteStateMachine").change_state("Death")
				dead = true
			

func _ready():
	health_bar.health = 100

func _process(_delta):
	direction = player.position - position
	
	sprite.flip_h = direction.x < 0

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

func hit(dmg):
	hp -= dmg * 0.1
