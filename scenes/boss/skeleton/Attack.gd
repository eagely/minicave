extends Skel

var can_damage = false
@onready var melee_area = $"../../MeleeArea"


func enter():
	super.enter()
	combo()

func attack(move = "1"):
	animation_player.play("attack_" + move)
	await animation_player.animation_finished


func combo():
	var move_set = ["1","1","2"]
	for i in move_set:
		await attack(i)
	
	combo()

func transition():
	if owner.direction.length() > 150:
		can_damage = false
		get_parent().change_state("Follow")


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
	body.hit(10)
	can_damage = false
