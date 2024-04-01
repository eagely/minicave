extends Skel

func enter():
	super.enter()
	animation_player.play("death")
	GameManager.boss_slain()
	owner.queue_free()

