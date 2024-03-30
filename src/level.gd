extends Node2D

func show_jump(area):
	if area.get_parent().name == "Player":
		$Tutorial/Walk/Label.text = ""
		$Tutorial/Jump/Label.text = "Jump with Space"
	
func show_duck(area):
	if area.get_parent().name == "Player":
		$Tutorial/Jump/Label.text = ""
		$Tutorial/Duck/Label.text = "Duck using Shift"
	
func show_attack(area):
	if area.get_parent().name == "Player":
		$Tutorial/Duck/Label.text = ""
		$Tutorial/Attack/Label.text = "Attack using Left Click"
	
func show_teleport(area):
	if area.get_parent().name == "Player":
		$Tutorial/Attack/Label.text = ""
		$Tutorial/Teleport/Label.text = "Press E and left click a location to teleport there"
	
func _on_finish_area_entered(area):
	GameManager.stop_tutorial()
