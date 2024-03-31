extends State

@onready var fsm = get_parent()
@onready var melee_area = owner.find_child("MeleeArea")
var can_damage = false

func enter():
	super.enter()
	animation.play("melee_attack")
	
func transition():
	if owner.direction.length() > 64:
		fsm.change_state("Follow")

func start_damaging():
	can_damage = true
	for body in melee_area.get_overlapping_bodies():
		if body == GameManager.player:
			apply_damage(body)


func _on_melee_area_body_entered(body):
	if can_damage and body == GameManager.player:
		apply_damage(body)


func apply_damage(body):
	GameManager.play_large_hit(global_position)
	body.hit(20)
	can_damage = false
