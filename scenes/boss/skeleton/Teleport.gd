extends Skel
 
var can_transition: bool = false
 
func enter():
	super.enter()
	animation_player.play("teleport")
	await animation_player.animation_finished
	can_transition = true
 
 
func teleport():
	owner.global_position = player.global_position + Vector2.RIGHT * 40
 
 
func transition():
	if can_transition:
		get_parent().change_state("Attack")
		can_transition = false
 
