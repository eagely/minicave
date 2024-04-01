extends Area2D


@onready var sprite = find_child("Animation")

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var speed = 250

func _physics_process(delta):
	acceleration = (GameManager.player.position - position).normalized() * 700
	
	velocity += acceleration * delta
	rotation = velocity.angle()
	
	velocity = velocity.limit_length(speed)
	position += velocity * delta


func _on_area_entered(area):
	(area)
	if area.get_parent() and area.get_parent().name.contains("PlayerBullet"):
		area.queue_free()
	queue_free()


func _on_alive_time_timeout():
	queue_free()


func _on_body_entered(body):
	if body == GameManager.player:
		GameManager.play_small_hit(global_position)
		body.hit(10)
		queue_free()		
	elif body.name.contains("PlayerBullet"):
		body.queue_free()
		queue_free()
	
