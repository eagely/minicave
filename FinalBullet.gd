extends Area2D

var direction
var speed = 700

func _ready():
	direction = (GameManager.player.position - position).normalized()
	
	
func _physics_process(delta):
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body == GameManager.player:
		body.hit(25)
