extends Node

func _ready():
	$Player.visible = false
	$Mob.visible = false


func _process(delta):
	if Input.is_action_just_pressed("escape"):
		pause_game()

func _on_menu_start_game():
	start_game()

func start_game():
	$Menu.hide()
	$Player.show()
	$Mob.show()
	
func pause_game():
	$Player.hide()
	$Mob.hide()
	$Menu.show()
