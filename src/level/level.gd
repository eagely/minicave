extends Node2D

@onready var keybinds = ConfigFileHandler.load_keybindings()

func show_jump(area):
	if area.name == "Player":
		$Tutorial/Walk/Label.text = ""
		$Tutorial/Jump/Label.text = "Jump with " + ConfigFileHandler.get_display_name(keybinds.jump)
	
func show_duck(area):
	if area.name == "Player":
		$Tutorial/Jump/Label.text = ""
		$Tutorial/Duck/Label.text = "Duck using " + ConfigFileHandler.get_display_name(keybinds.duck)
	
func show_attack(area):
	if area.name == "Player":
		$Tutorial/Duck/Label.text = ""
		$Tutorial/Attack/Label.text = "Attack using Left Click"
	
func show_teleport(area):
	if area.name == "Player":
		$Tutorial/Attack/Label.text = ""
		$Tutorial/Teleport/Label.text = "Swap between ranged and melee with " + ConfigFileHandler.get_display_name(keybinds.cycle_attack_mode)
	
func _on_finish_area_entered(area):
	GameManager.stop_tutorial()
