extends Area2D

var enabled = true

func _ready():
	$Animation.play("idle")


func disable():
	$Animation.stop()
	hide()
	enabled = false


func enable():
	show()
	$Animation.play("idle")	
	enabled = true


func _on_body_entered(body):
	if enabled and body == GameManager.player:
			GameManager.load_next_level()
