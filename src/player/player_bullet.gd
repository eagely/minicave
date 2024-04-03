extends CharacterBody2D


var direction = Vector2.RIGHT
var speed = 500
var damage = 1

func _physics_process(delta):
	velocity = direction * speed
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		queue_free()
	move_and_slide()


func _on_collision_area_body_entered(body):
	if body.is_in_group("Attackable"):
		body.hit(damage)
		queue_free()


func _on_alive_timer_timeout():
	queue_free()
