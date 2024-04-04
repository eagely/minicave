extends Final

func enter():
	super.enter()
	animation.play("death")
	await animation.animation_finished
	await GameManager.boss_slain()
	GameManager.main.level.get_node("Finish").disable()
	owner.queue_free()
