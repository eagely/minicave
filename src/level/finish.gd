extends Area2D

var enabled = true
var timeout = 0

func _ready():
	$Animation.play("idle")


func disable():
	enabled = false	
	$Animation.stop()
	hide()


func enable():
	show()
	$Animation.play("idle")	
	enabled = true

func _process(delta):
	timeout -= delta
	if timeout < 0:
		timeout = 0

func _on_body_entered(body):
	if timeout <= 0 and enabled and body == GameManager.player:
		GameManager.load_next_level()
