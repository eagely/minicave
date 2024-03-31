extends State

@onready var fsm = get_parent()
var lasered = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	animation.play("idle")
	
func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	var distance = owner.direction.length()
	
	if distance <= 64:
		fsm.change_state("MeleeAttack")
	elif distance >= 256:
		if owner.hp <= 25 and not lasered:
			fsm.change_state("LaserBeam")
			lasered = true
		else:
			fsm.change_state("HomingMissile")
