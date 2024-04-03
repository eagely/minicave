extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$Animation.play("idle")

func _physics_process(delta):
	if is_on_floor():
		velocity.y = 300 * delta
	else:
		velocity.y = gravity * delta


func _on_area_2d_body_entered(body):
	if body == GameManager.player:
		body.velocity.y -= 800
