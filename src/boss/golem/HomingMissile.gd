extends State


@export var bullet_scene = preload("res://scenes/boss/golem/golem_bullet.tscn")
@onready var fsm = get_parent()
var can_transition = false

func enter():
	super.enter()
	animation.play("ranged_attack")
	await animation.animation_finished
	shoot()
	can_transition = true
	
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = owner.position
	GameManager.main.level.get_node("CoinHolder").add_child(bullet)
	
func transition():
	if can_transition:
		can_transition = false
		fsm.change_state("Dash")
