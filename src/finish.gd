extends Area2D

var enabled = true

func _ready():
	$Animation.play("idle")

func _on_area_entered(area):
	if enabled and area.get_parent().name == "Player" and not get_parent().has_node("Tutorial"):
		GameManager.load_next_level()
		
func disable():
	$Animation.stop()
	hide()
	enabled = false

func enable():
	show()
	$Animation.play("idle")	
	enabled = true
