extends Skel

func enter():
	super.enter()
	animation_player.play("death")
	await get_tree().create_timer(2.5).timeout
	await GameManager.boss_slain()
	owner.queue_free()

