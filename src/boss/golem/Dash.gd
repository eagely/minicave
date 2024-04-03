extends State


@onready var fsm = get_parent()
var can_transition = false

func enter():
	super.enter()
	animation.play("glowing")
	await dash()
	can_transition = true

func dash():
	var tween = create_tween()
	tween.tween_property(owner, "position", player.position, 0.8).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
func transition():
	if can_transition:
		can_transition = false
		fsm.change_state("Follow")
