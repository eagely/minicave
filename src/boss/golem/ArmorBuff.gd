extends State


@onready var fsm = get_parent()
var can_transition = false

func enter():
	super.enter()
	animation.play("armor_buff")
	await animation.animation_finished
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		fsm.change_state("Follow")
