extends Node

func _ready():
	$Level.visible = false	
	$Player.visible = false
	$Mob.visible = false


func _process(delta):
	if Input.is_action_just_pressed("escape"):
		pause_game()

func _on_menu_start_game():
	start_game()

func start_game():
	$Menu.hide()
	$Level.show()
	$Player.start($StartPosition.position)
	$Mob.show()
	
func pause_game():
	$Player.hide()
	$Mob.hide()
	$Level.hide()
	$Menu.show()
