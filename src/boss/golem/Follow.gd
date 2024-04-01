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
	else:
		if owner.hp <= 75 and randi() % 3 == 0:
			fsm.change_state("LaserBeam")
		else:
			fsm.change_state("HomingMissile")
