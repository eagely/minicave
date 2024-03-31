extends State


@onready var fsm = get_parent()
@onready var pivot = $"../../Pivot"
@onready var laser_area = pivot.find_child("LaserArea")
var can_transition = false
var can_damage = false

func play_animation(anim_name):
	animation.play(anim_name)
	await animation.animation_finished
	
func enter():
	super.enter()
	await play_animation("laser_cast")
	await play_animation("laser")
	can_damage = false
	can_transition = true

func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()

func transition():
	if can_transition:
		can_transition = false
		fsm.change_state("Dash")


func start_damaging():
	can_damage = true
	for body in laser_area.get_overlapping_bodies():
		if body == GameManager.player:
			apply_damage(body)

func _on_laser_area_body_entered(body):
	if can_damage and body == GameManager.player:
		apply_damage(body)

func apply_damage(body):
	GameManager.play_large_hit(global_position)
	GameManager.frame_freeze(0.05, 1)
	body.hit(50)
	can_damage = false
