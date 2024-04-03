extends Final

func enter():
	super.enter()
	animation.play("death")
	await animation.animation_finished
	await GameManager.boss_slain()
	owner.queue_free()
