extends Skel

func enter():
	super.enter()
	animation_player.play("death")
	await animation_player.animation_finished
	await GameManager.boss_slain()
	owner.queue_free()

