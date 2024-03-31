extends Node2D

var strength = 50


func _on_hitbox_area_body_entered(body):
	if body == GameManager.player:
		body.hit(strength)
