extends State


func enter():
	super.enter()
	owner.find_child("Label").text = ""
	var tween = create_tween()
	tween.tween_property(owner, "position", owner.spawnpoint, 0.8)
	await tween.finished
	animation.play("death")
	await animation.animation_finished
	animation.play("boss_slain")
	$DeathTimer.start()
	await $DeathTimer.timeout
	await GameManager.boss_slain()
	owner.queue_free()

